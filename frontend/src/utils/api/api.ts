import axios, { type AxiosInstance } from 'axios'
import { useAuthStore } from '@/stores/auth';


export class Api {
  protected instance: AxiosInstance
  constructor() {
    this.instance = axios.create({
      baseURL: import.meta.env.MODE === 'development' ? import.meta.env.VITE_BACKEND_URL + '/api' : 'https://time-manager-api-nan-2-main.onrender.com/api',
      timeout: 1000,
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json'
      },
      withCredentials: true // This ensures cookies are sent with the request
    })
    // Ajouter le token XSRF aux headers des requêtes
    this.instance.interceptors.request.use(
      (config) => {
        const authStore = useAuthStore();
        const xsrfToken = authStore.xsrfToken;
        if (xsrfToken) {
          config.headers['c-xsrf-token'] = xsrfToken;
        }
        return config;
      },
      (error) => {
        return Promise.reject(error);
      }
    );
  }
}