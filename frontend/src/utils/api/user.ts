import { Api } from "./api";

export class UserApi extends Api {
    constructor() {
        super();
    }

    async getUserByID(userId: string) {
        try {
            const response = await this.instance.get(`/user/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async getUserByMailAndUsername(email: string, username: string) {
        try {
            const response = this.instance.get(`/user?email=${email}&username=${username}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async createUser(username: string, email: string, password: string) {
        try {
            const response = this.instance.post(`/users`, {
                username: username,
                email: email,
                password: password
            });
            //const response = this.instance.post(`/user`);
            console.log('je suis ici', response);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async updateUser(userId: string) {
        try {
            const response = this.instance.put(`/user/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }   

    async deleteUser(userId: string) {
        try {
            const response = this.instance.delete(`/user/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }
}
