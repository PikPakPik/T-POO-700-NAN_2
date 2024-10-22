//utils
import { TeamsApi } from '~/src/utils/api/teams';

export const useTeams = () => {
    const teamApi = new TeamsApi();
    let err: string | null = null;

    const getTeams = async () => {
        const response = await teamApi.getTeams();
        if (response?.status !== 200) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
        if (response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const createTeams = async (teamName: string) => {
        try {
            const teamData = {
                team: {
                    name: teamName
                }
            };
            const response = await teamApi.createTeams(teamData);
            if (response?.status !== 201) {
                throw new Error('Problem with server');
            }
            if (response && response.data && response.data.data) {
                return response.data.data;
            }
        } catch (err) {
            throw new Error('Échec de la création de l\'équipe');
        }
    }

    const deleteTeam = async (teamId: string) => {
        const response = await teamApi.deleteTeam(teamId);
        if (response?.status !== 204) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
    }

    const updateTeam = async (teamId: string, teamName: string) => {
        const teamData = {
            team: {
                name: teamName
            }
        };
        const response = await teamApi.updateTeam(teamId, teamData);
        if (response?.status !== 200) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
        if (response && response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const showTeam = async (teamId: string) => {
        const response = await teamApi.getTeamByID(teamId);
        if (response?.status !== 200) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
        if (response && response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const associateManager = async (teamId: string, managerId: string) => {
        const response = await teamApi.addManagerToTeam(teamId, managerId);
        if (response?.status !== 200) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
        if (response && response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const associateEmployee = async (teamId: string, employeeId: string) => {
        const response = await teamApi.addEmployeeToTeam(teamId, employeeId);
        if (response?.status !== 200) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
        if (response && response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const removeEmployeeFromTeam = async (teamId: string, employeeId: string) => {
        const response = await teamApi.removeEmployeeFromTeam(teamId, employeeId);
        if (response?.status !== 200) {
            throw new Error('Équipe introuvable ou problème serveur');
        }
        if (response && response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    return { 
        err,
        getTeams,
        createTeams,
        deleteTeam,
        updateTeam,
        showTeam,
        associateManager,
        associateEmployee,
        removeEmployeeFromTeam,
    };
}

export default useTeams
