import axios, { type AxiosInstance } from 'axios';
import { useAuthStore } from '@/stores/auth';

export class Api {
  protected instance: AxiosInstance;

  constructor() {
    axios.defaults.withCredentials = true
    this.instance = axios.create({
      baseURL: import.meta.env.MODE === 'development' ?
               import.meta.env.VITE_BACKEND_URL + '/api' :
               'https://time-manager-api-nan-2-main.onrender.com/api',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      }
    })
    // Add the XSRF token to the request headers
    this.instance.interceptors.request.use(
      (config) => {
        const authStore = useAuthStore();
        let xsrfToken = authStore.xsrfToken;
        if (!xsrfToken) {
          xsrfToken = localStorage.getItem('xsrf_token');
        }

        if (xsrfToken) {
          config.headers['c-xsrf-token'] = xsrfToken;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    this.instance.interceptors.request.use(
      (config) => {
        if (!navigator.onLine) {
          this.storeOfflineRequest(config);
          return Promise.reject(new Error('Pas de réseau, la requête est stockée.'));
        }

        if (config.method?.toLowerCase() === 'post' && config.url?.includes('/clocks/')) {
          this.handleClockRequest(config);
        }

        return config;
      },
      (error) => Promise.reject(error)
    );
  }

  private handleClockRequest(config: any) {
    const userId = this.extractUserIdFromUrl(config.url);
    if (!userId) {
      return;
    }
    const pendingRequests = JSON.parse(localStorage.getItem('pendingRequests') || '[]');
    const existingClock = pendingRequests.find((req: any) => req.url.includes(`/clocks/${userId}/time`));

    if (existingClock) {
      const startTime = new Date(existingClock.timestamp);
      const endTime = new Date();

      this.createWorkingTime(endTime, startTime, userId);

      pendingRequests[pendingRequests.indexOf(existingClock)] = {
        url: `/clocks/${userId}/time`,
        method: 'post',
        timestamp: endTime.toISOString(),
        data: {
          ...config.data,
          datetime: endTime.toISOString()
        },
      };
    } else {
      const clockRequest = {
        url: `/clocks/${userId}/time`,
        method: 'post',
        timestamp: new Date().toISOString(),
        data: {
          ...config.data,
          datetime: new Date().toISOString()
        },
      };
      pendingRequests.push(clockRequest);
    }
    localStorage.setItem('pendingRequests', JSON.stringify(pendingRequests));
  }

  private extractUserIdFromUrl(url: string) {
    const match = url.match(/\/clocks\/(\d+)/);
    return match ? parseInt(match[1], 10) : null;
  }

  private storeOfflineRequest(config: any) {
    if (config.method?.toLowerCase() === 'get') {
      return;
    }

    const request = {
      url: config.url,
      method: config.method,
      data: config.data,
      headers: config.headers,
      params: config.params,
      timestamp: new Date().toISOString(),
    };

    const pendingRequests = JSON.parse(localStorage.getItem('pendingRequests') || '[]');
    pendingRequests.push(request);
    localStorage.setItem('pendingRequests', JSON.stringify(pendingRequests));
  }

  public async replayStoredRequests() {
    const pendingRequests = JSON.parse(localStorage.getItem('pendingRequests') || '[]');
    if (pendingRequests.length === 0) {
      return;
    }

    for (const request of pendingRequests) {
      try {
        const response = await this.instance({
          url: request.url,
          method: request.method,
          data: request.data,
          headers: request.headers,
          params: request.params,
        });

      } catch (error) {
        console.error('Erreur lors de la reprise des requêtes stockées', error);
      }
    }

    localStorage.removeItem('pendingRequests');
  }

  private async createWorkingTime(end: Date, start: Date, user_id: number) {
    const workingTime = {
      working_time: {
        end: end.toISOString(),
        start: start.toISOString(),
        user_id: user_id,
      },
    };

    const workingTimeRequest = {
      url: `/workingtime/${user_id}`,
      method: 'post',
      data: workingTime,
      timestamp: new Date().toISOString(),
    };

    this.storeOfflineRequest(workingTimeRequest);

    try {
      const response = await this.instance.post(`/workingtime/${user_id}`, workingTime);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la création du working time :', error);
      throw error;
    }
  }
}
