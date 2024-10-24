<template>
    <div>
        <getTeams />
    </div>
</template>

<script>
//components
import getTeams from '~/src/components/teams/getTeams.vue';

definePageMeta({
    middleware: ['global-role'],
    meta: {
        roles: ['Admin', 'Manager', 'Employee'], // Rôles requis pour accéder à cette page
    },
})

export default {
    components: {
        getTeams,
    }
}

</script>