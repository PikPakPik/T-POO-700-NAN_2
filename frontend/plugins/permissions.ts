// plugins/permissions.ts
import { defineNuxtPlugin } from '#app'
import { useAuthStore } from '@/stores/auth';

export default defineNuxtPlugin(nuxtApp => {
    const authStore = useAuthStore();

    //   nuxtApp.vueApp.directive('can', {
    //     mounted(el, binding) {
    //       const permissions = authStore.getUserPermissions;
    //       if (!permissions.includes(binding.value)) {
    //         el.parentNode && el.parentNode.removeChild(el);
    //       }
    //     },
    //   });

    //   nuxtApp.vueApp.directive('can-not', {
    //     mounted(el, binding) {
    //       const permissions = authStore.getUserPermissions;
    //       if (permissions.includes(binding.value)) {
    //         el.parentNode && el.parentNode.removeChild(el);
    //       }
    //     },
    //   });

    nuxtApp.vueApp.directive('role', {
        mounted(el, binding) {
            const roles = authStore.getUserRoles;
            if (!roles.includes(binding.value)) {
                el.parentNode && el.parentNode.removeChild(el);
            }
        },
    });

    nuxtApp.vueApp.directive('role-not', {
        mounted(el, binding) {
            const roles = authStore.getUserRoles;
            if (roles.includes(binding.value)) {
                el.parentNode && el.parentNode.removeChild(el);
            }
        },
    });
});