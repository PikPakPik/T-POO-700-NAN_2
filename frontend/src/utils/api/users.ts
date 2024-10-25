import { Api } from "./api";

export class UsersApi extends Api {
    constructor() {
        super();
    }

    async login(userData: { email: string, password: string }) {
        try {
            const response = await this.instance.post(`/users/sign_in`, userData);
            return response;
        } catch (error) {
            console.error('Error in UsersApi login:', error);
            throw error; // Re-throw the error to be caught in the calling function
        }
    }

    async logout() {
        try {
            const response = await this.instance.post(`/users/sign_out`);
            return response;
        } catch (error) {
            console.error('Error in UsersApi logout:', error);
            throw error; // Re-throw the error to be caught in the calling function
        }
    }

    async getUsers() {
        try {
            const response = await this.instance.get(`/users`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async getUserByID(userId: string) {
        try {
            const response = await this.instance.get(`/users/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async getUserByMailAndUsername(email: string, username: string) {
        try {
            const response = await this.instance.get(`/users?email=${email}&username=${username}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async createUser(userData: { user: { username: string; email: string; password: string; role: string; }; }) {
        try {
            console.log('userData2', userData);
            const response = await this.instance.post(`/users`, userData);
            console.log('response:', response);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async updateUser(userId: string, userData: { user: { username: string, email: string } }) {
        try {
            const response = await this.instance.put(`/users/${userId}`, userData);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async updateUserRole(userId: string, roleId: string) {
        try {
            const response = await this.instance.put(`/users/${userId}/role/${roleId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async deleteUser(userId: string) {
        try {
            const response = await this.instance.delete(`/users/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async getUserWorkingTimes(userId: string, startDate?: string, endDate?: string) {
        const startQuery = startDate ? `&start=${startDate}` : '';
        const endQuery = endDate ? `&end=${endDate}` : '';
        try {
            const response = await this.instance.get(`/workingtime/${userId}?${startQuery}${endQuery}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }
}