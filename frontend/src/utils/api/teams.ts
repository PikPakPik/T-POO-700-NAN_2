import { tr } from "vuetify/locale";
import { Api } from "./api";

export class TeamsApi extends Api {

    constructor() {
        super();
    }

    async getTeams() {
        try {
            const response = await this.instance.get(`/teams`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async getTeamByID(teamId: string) {
        try {
            const response = await this.instance.get(`/teams/${teamId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async createTeams(teamData: { team: { name: string } }) {
        try {
            const response = await this.instance.post(`/teams`, teamData);
            return response
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async clockTeam(teamId: string) {
        try {
            const response = await this.instance.post(`/teams/${teamId}/clock`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async updateTeam(teamId: string, teamData: { team: { name: string } }) {
        try {
            const response = await this.instance.put(`/teams/${teamId}`, teamData);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async addEmployeeToTeam(teamId: string, userId: string) {
        try {
            const response = await this.instance.put(`/teams/${teamId}/add_employee/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async addManagerToTeam(teamId: string, userId: string) {
        try {
            const response = await this.instance.put(`/teams/${teamId}/add_manager/${userId}`);
            return response;
        } catch (error) {

            console.error(error);
            return null;
        }
    }

    async removeEmployeeFromTeam(teamId: string, userId: string) {
        try {
            const response = await this.instance.put(`/teams/${teamId}/remove_employee/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async removeManagerFromTeam(teamId: string, userId: string) {
        try {
            const response = await this.instance.put(`/teams/${teamId}/remove_manager/${userId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async deleteTeam(teamId: string) {
        try {
            const response = await this.instance.delete(`/teams/${teamId}`);
            return response;
        } catch (error) {
            console.error(error);
            return null;
        }
    }

    async getTeamClocks(teamId: string) {
        try {
            const response = await this.instance.get(`/teams/${teamId}/clocks`);
            return response
        } catch (error) {
            console.error(error);
            return null;
        }
    }
}
