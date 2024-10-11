import { Api } from "./api";

export class WorkingTimeApi extends Api {
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
            const api = new WorkingTimeApi();
            const response = await api.instance[method](url, data);
            return response.data;
        } catch (error) {
            console.error(`Error in ${method} request:`, error);
            throw error;
        }
    }

    /**
     * Creates a new working time entry for a user.
     *
     * @param end - The end time of the working period.
     * @param start - The start time of the working period.
     * @param user_id - The ID of the user for whom the working time is being created.
     * @returns A promise that resolves to the response of the API request.
     */
    static async createWorkingTime(end: Date, start: Date, user_id: number) {
        const workingTime = {
            working_time: {
                end: end,
                start: start,
                // end: end.toISOString(),
                // start: start.toISOString(),
                user_id: user_id
            }
        };
        return WorkingTimeApi.makeRequest('post', `/workingtime/${user_id}`, workingTime);
    }

    /**
     * Updates the working time for a specific user.
     *
     * @param id - The ID of the working time entry to update.
     * @param end - The end time of the working period.
     * @param start - The start time of the working period.
     * @param user_id - The ID of the user whose working time is being updated.
     * @returns A promise that resolves with the response from the API.
     */
    static async updateWorkingTime(id: number, end: Date, start: Date, user_id: number) {
        const workingTime = {
            working_time: {
                end: end,
                start: start,
                user_id: user_id
            }
        };
        return WorkingTimeApi.makeRequest('put', `/workingtime/${id}`, workingTime);
    }

    /**
     * Deletes a working time entry by its ID.
     *
     * @param {number} id - The ID of the working time entry to delete.
     * @returns {Promise<void>} A promise that resolves when the working time entry is successfully deleted.
     */
    static async deleteWorkingTime(id: number): Promise<void> {
        return WorkingTimeApi.makeRequest('delete', `/workingtime/${id}`);
    }

    /**
     * Reads the working time for a specific user.
     *
     * @param user_id - The ID of the user whose working time is to be read.
     * @returns A promise that resolves to void.
     */
    static async readWorkingTimes(user_id: number): Promise<void> {
        return WorkingTimeApi.makeRequest('get', `/workingtime/${user_id}`);
    }

    static async readWorkingTime(user_id: number, id: number): Promise<void> {
        return WorkingTimeApi.makeRequest('get', `/workingtime/${user_id}/${id}`);
    }
}

export const { updateWorkingTime, createWorkingTime, deleteWorkingTime, readWorkingTime, readWorkingTimes } = WorkingTimeApi;