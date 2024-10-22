<template>
    <a href="#" @click="logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
        role="menuitem">Déconnexion</a>
</template>

<script lang="ts">
import { useAuthStore } from '@/stores/auth';

export default {
    name: 'LogoutButton',
    methods: {
        async logout(event: Event) {
            try {
                event.preventDefault();
                const authStore = useAuthStore();
                authStore.logout();
                this.$router.push('/auth');
            } catch (error) {
                console.error(error);
            }
        }
    }
}
</script>