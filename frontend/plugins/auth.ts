import { useAuthStore } from '@/stores/auth';
import useUsers from '~/src/utils/user/user';

const { getUser } = useUsers();

export default defineNuxtPlugin(async (nuxtApp) => {
    const authStore = useAuthStore();
    console.log('authStore', authStore)
    if (!authStore.getCurrentUser) {
        try {
            const userID = localStorage.getItem('userID');
            if (userID) {
                const user = await getUser(userID);
                if (user) {
                    const xsrfToken = localStorage.getItem('xsrf_token');
                    if (xsrfToken) {
                        // Initialize store on page load/refresh
                        authStore.initializeStore(user, xsrfToken);
                    }
                } else {
                    navigateTo('/auth');
                }
            }
        } catch (error) {
            console.error('Failed to fetch user:', error);
            navigateTo('/auth');
        }
    }
})