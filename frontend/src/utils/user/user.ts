//utils
import { UsersApi } from '~/src/utils/api/users';

export const useUsers = () => {
    const userApi = new UsersApi();
    let err: string | null = null;

    const login = async (email: string, password: string) => {
        const response = await userApi.login({ email, password });
        if (response?.status !== 200) {
            throw new Error('authentification impossible');
        }
        return response;
    }

    const logout = async () => {
        const response = await userApi.logout();
        if (response?.status !== 204) {
            throw new Error('déconnexion impossible');
        }
        return response;
    }

    const getUsers = async () => {
        const response = await userApi.getUsers();
        if (response?.status !== 200) {
            throw new Error('Utilisateur introuvable ou problème serveur');
        }
        if (response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const getUser = async (userId: string) => {
        const response = await userApi.getUserByID(userId);
        if (response?.status !== 200) {
            throw new Error('Utilisateur introuvable ou problème serveur');
        }
        if (response.data && response.data.data) {
            return response.data.data;
        } else {
            throw new Error('Data not found');
        }
    }

    const createUser = async (username: string, email: string, password: string, role: string) => {
        try {
            const userData = {
                user: {
                    username: username,
                    email: email,
                    password: password,
                    role: role
                }
            };
            console.log('userData1', userData);
            const response = await userApi.createUser(userData);
            if (response?.status !== 201) {
                throw new Error('Problem with server');
            }
            if (response && response.data && response.data.data) {
                return response.data.data;
            }
        } catch (err) {
            throw new Error('Échec de la création de l\'utilisateur');
        }
    }

    const updateUser = async (userId: string, username: string, email: string) => {
        try {
            const userData = {
                user: {
                    username: username,
                    email: email,
                }
            };
            const response = await userApi.updateUser(userId, userData);
            if (response?.status !== 200) {
                throw new Error('Problem with server');
            }
            if (response && response.data && response.data.data) {
                return response.data.data;
            }
        } catch (err) {
            throw new Error('Échec de la mise à jour de l\'utilisateur');
        }
    }

    const updateUserRole = async (userId: string, roleId: string) => {
        try {
            const response = await userApi.updateUserRole(userId, roleId);
            if (response?.status !== 200) {
                throw new Error('Problem with server');
            }
            if (response && response.data && response.data.data) {
                return response.data.data;
            }
        } catch (err) {
            throw new Error('Échec de la mise à jour du rôle de l\'utilisateur');
        }
    }

    const deleteUser = async (userId: string) => {
        try {
            await userApi.deleteUser(userId);
        } catch (err) {
            throw new Error('Échec de la suppression de l\'utilisateur');
        }
    }

    return {
        err,
        getUsers,
        getUser,
        createUser,
        updateUser,
        updateUserRole,
        deleteUser,
        login,
        logout,
    };
}

export default useUsers