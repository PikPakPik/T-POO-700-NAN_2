import { defineStore } from 'pinia';
import type { AuthState, User } from '../src/types/auth';

export const useAuthStore = defineStore('auth', {
    state: (): AuthState => ({
        user: null as User | null,
        xsrfToken: null as string | null,
        roles: [] as string[], // Ajoutez les rôles
        permissions: [] as string[], // Ajoutez les permissions
        loginTimestamp: null as string | null,
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
        SET_LOGIN_TIMESTAMP(timestamp: string | null) {
            this.loginTimestamp = timestamp;
        },
        login(user: User, xsrf_token: string) {
            try {
                this.SET_USER(user);
                this.SET_XSRF_TOKEN(xsrf_token);
                this.SET_ROLES([user.role.name]);

                const timestamp = new Date().toISOString();
                this.SET_LOGIN_TIMESTAMP(timestamp);

                localStorage.setItem('userID', user.id.toString());
                localStorage.setItem('xsrf_token', xsrf_token);
                localStorage.setItem('loginTimestamp', timestamp);
            } catch (error) {
                console.error('Error logging in:', error);
                throw error;
            }
        },
        logout() {
            this.SET_USER(null);
            this.SET_XSRF_TOKEN(null);
            this.SET_ROLES([]);
            this.SET_LOGIN_TIMESTAMP(null);
            localStorage.removeItem('userID');
            localStorage.removeItem('xsrf_token');
            localStorage.removeItem('loginTimestamp');
        },
        initializeStore(user: User, xsrfToken: string) {
            this.SET_USER(user);
            this.SET_XSRF_TOKEN(xsrfToken);
            this.SET_ROLES([user.role.name]);

            const timestamp = localStorage.getItem('loginTimestamp');
            if (timestamp) {
                this.SET_LOGIN_TIMESTAMP(timestamp);
            }
        }
    },
    getters: {
        getCurrentUser: (state: AuthState) => state.user,
        getXsrfToken: (state: AuthState) => state.xsrfToken,
        getUserRoles: (state: AuthState) => state.roles,
        getUserPermissions: (state: AuthState) => state.permissions,
        getLoginTimestamp: (state: AuthState) => state.loginTimestamp,
        isAdmin: (state: AuthState) => state.roles.includes('Admin'),
        isManager: (state: AuthState) => state.roles.includes('Manager' || 'Admin'),
        isEmployee: (state: AuthState) => state.roles.includes('Employee' || 'Manager' || 'Admin'),
    },
});
