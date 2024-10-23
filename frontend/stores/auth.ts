import { defineStore } from 'pinia';
import type { AuthState, User } from '../src/types/auth';

export const useAuthStore = defineStore('auth', {
    state: (): AuthState => ({
        user: null as User | null,
        xsrfToken: null as string | null,
    }),
    actions: {
        SET_USER(user: User | null) {
            this.user = user;
        },
        SET_XSRF_TOKEN(xsrfToken: string | null) {
            this.xsrfToken = xsrfToken;
        },
        login(user: User, xsrf_token: string) {
            try {
                this.SET_USER(user);
                this.SET_XSRF_TOKEN(xsrf_token);
                // const userPermissions = useCookie('permissions');
                const userRoles = useCookie('roles');
                // userPermissions.value = user.permissions; // ['read posts', ..., 'delete posts']
                userRoles.value = user.role.name; // ['admin', 'editor']

            } catch (error) {
                console.error('Error logging in:', error);
                throw error;
            }
        },
        logout() {
            this.SET_USER(null);
            this.SET_XSRF_TOKEN(null);
        }
    },
    getters: {
        getCurrentUser: (state: AuthState) => state.user,
        getXsrfToken: (state: AuthState) => state.xsrfToken,
    },
});