import { defineStore } from 'pinia';
import type { AuthState, User } from '../src/types/auth';
import { UsersApi } from '../src/utils/api/users';

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
        async login(email: string, password: string) {
            const usersApi = new UsersApi();
            try {
                const response = await usersApi.login({ email, password });
                if (response && response.data) {
                    const { user, xsrf_token } = response.data;
                    this.user = user;
                    this.xsrfToken = xsrf_token;
                } else {
                    throw new Error('Login failed');
                }
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