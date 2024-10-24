<template>
    <workingTimes :userID="$route.params.userID" />
</template>

<script>
import workingTimes from '@/src/components/workingTimes.vue';

definePageMeta({
    middleware: ['global-role'],
    meta: {
        roles: ['Admin', 'Manager', 'Employee'], // Rôles requis pour accéder à cette page
    },
})

export default {
    components: {
        workingTimes
    }
}
</script>