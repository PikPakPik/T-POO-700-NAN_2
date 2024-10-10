import { Api } from "./api";

export class UsersApi extends Api {
    constructor() {
        super();
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
            const response = this.instance.get(`/users?email=${email}&username=${username}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async createUser(userData: { user: { username: string, email: string } }) {
        try {
            const response = this.instance.post(`/users`, userData);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async updateUser(userId: string, userData: { user: { username: string, email: string } }) {
        try {
            const response = this.instance.put(`/users/${userId}`, userData);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }   

    async deleteUser(userId: string) {
        try {
            const response = this.instance.delete(`/users/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }
}
