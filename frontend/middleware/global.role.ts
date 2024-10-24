import { defineNuxtRouteMiddleware } from '#app';
import { useAuthStore } from '@/stores/auth';
import { toast } from 'vue3-toastify'

export default defineNuxtRouteMiddleware((to, from) => {
    const authStore = useAuthStore();

    // Check if user is authenticated
    if (!authStore.getXsrfToken) {
        return navigateTo('/auth');
    }

    const userRoles = authStore.getUserRoles;
    const meta = to.meta as { meta: { roles: string[] } };
    const requiredRoles = meta.meta.roles || [];

    if (!requiredRoles.some((role: string) => userRoles.includes(role))) {
        toast.error('Vous n\'avez pas les permissions nécessaires pour accéder à cette page.', {
            position: toast.POSITION.TOP_CENTER,
            autoClose: 3000
        });
        return false; // Annule l'action demandée
    }
});