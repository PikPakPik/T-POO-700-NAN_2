<template>
    <div>
        <getUser />
    </div>
</template>

<script>
//components
import getUser from '~/src/components/users/getUser.vue';

definePageMeta({
    middleware: ['global-role'],
    meta: {
        roles: ['Admin', 'Manager', 'Employee'], // Rôles requis pour accéder à cette page
    },
})

export default {
    components: {
        getUser,
    }
}

</script>