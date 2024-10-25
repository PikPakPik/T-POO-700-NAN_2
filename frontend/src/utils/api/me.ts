import { Api } from "./api";

export class MeApi extends Api {
    constructor() {
        super();
    }

    /**
     * Makes an HTTP request using the specified method, URL, and data.
     *
     * @template T - The expected response type.
     * @param {('post' | 'put' | 'delete' | 'get')} method - The HTTP method to use for the request.
     * @param {string} url - The URL to which the request is sent.
     * @param {any} [data] - The data to be sent with the request (optional).
     * @returns {Promise<T>} - A promise that resolves to the response data of type T.
     * @throws Will throw an error if the request fails.
     */
    private static async makeRequest<T>(
        method: 'post' | 'put' | 'delete' | 'get',
        url: string,
        data?: any
    ): Promise<T> {
        try {
            const api = new MeApi();
            const response = await api.instance[method](url, data);
            return response.data;
        } catch (error) {
            console.error(`Error in ${method} request:`, error);
            throw error;
        }
    }

    static async meClockInOrOut(): Promise<any> {
        return MeApi.makeRequest('post', `/me/clock`);
    }
    static async meGetClock(): Promise<any> {
        return MeApi.makeRequest('get', `/me/clock`);
    }
    static async meWorkingTimesDated(start: string, end: string): Promise<any> {
        const startQuery = start ? `&start=${start}` : '';
        const endQuery = end ? `&end=${end}` : '';
        return MeApi.makeRequest('get', `/me/workingtimes?${startQuery}${endQuery}`);
    }

    static async meReadWorkingTimes(): Promise<void> {
        return MeApi.makeRequest('get', `/me/workingtimes`);
    }
    static async meTeams(): Promise<any> {
        return MeApi.makeRequest('get', `/me/teams`);
    }
    static async meGetUser(): Promise<any> {
        return MeApi.makeRequest('get', `/me`);
    }
    static async mePutUser(): Promise<any> {
        return MeApi.makeRequest('put', `/me`);
    }
    static async meDeleteUser(): Promise<any> {
        return MeApi.makeRequest('delete', `/me`);
    }

}

export const {
    meClockInOrOut,
    meWorkingTimesDated,
    meReadWorkingTimes,
    meTeams,
    meGetUser,
    meGetClock,
    mePutUser,
    meDeleteUser
} = MeApi;