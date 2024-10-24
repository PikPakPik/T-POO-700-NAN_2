import { defineStore } from 'pinia';
import type { AuthState, User } from '../src/types/auth';

export const useAuthStore = defineStore('auth', {
    state: (): AuthState => ({
        user: null as User | null,
        xsrfToken: null as string | null,
        roles: [] as string[], // Ajoutez les rôles
        permissions: [] as string[], // Ajoutez les permissions
    }),
    actions: {
        SET_USER(user: User | null) {
            this.user = user;
        },
        SET_XSRF_TOKEN(xsrfToken: string | null) {
            this.xsrfToken = xsrfToken;
        },
        SET_ROLES(roles: string[]) {
            this.roles = roles;
        },
        SET_PERMISSIONS(permissions: string[]) {
            this.permissions = permissions;
        },
        login(user: User, xsrf_token: string) {
            try {
                this.SET_USER(user);
                this.SET_XSRF_TOKEN(xsrf_token);
                this.SET_ROLES([user.role.name]);

                //user & xsrf in local storage
                localStorage.setItem('userID', user.id.toString());
                const userID = localStorage.getItem('userID');
                localStorage.setItem('xsrf_token', xsrf_token);
            } catch (error) {
                console.error('Error logging in:', error);
                throw error;
            }
        },
        logout() {
            this.SET_USER(null);
            this.SET_XSRF_TOKEN(null);
            this.SET_ROLES([]);
            localStorage.setItem('userID', '');
            localStorage.setItem('xsrf_token', '');

        },
        initializeStore(user: User, xsrfToken: string) {
            this.SET_USER(user);
            this.SET_XSRF_TOKEN(xsrfToken);
            this.SET_ROLES([user.role.name]);
        }
    },
    getters: {
        getCurrentUser: (state: AuthState) => state.user,
        getXsrfToken: (state: AuthState) => state.xsrfToken,
        getUserRoles: (state: AuthState) => state.roles,
        getUserPermissions: (state: AuthState) => state.permissions,
    },
});