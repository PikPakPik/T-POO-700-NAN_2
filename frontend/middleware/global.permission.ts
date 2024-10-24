import { defineNuxtRouteMiddleware } from '#app';
import { useAuthStore } from '@/stores/auth';

export default defineNuxtRouteMiddleware((to, from) => {
    const authStore = useAuthStore();
    const userPermissions = authStore.getUserPermissions;
    const meta = to.meta as { meta: { permissions: string[] } };
    const requiredPermissions = meta.meta.permissions || [];

    if (!requiredPermissions.some((permission: string) => userPermissions.includes(permission))) {
        return navigateTo('/unauthorized');
    }
});