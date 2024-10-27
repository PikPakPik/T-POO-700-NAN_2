<template>
    <div>
        <getUser :userID="$route.params.userID"/>
    </div>
</template>

<script>
//components
import getUser from '~/src/components/users/getUser.vue';

definePageMeta({
    middleware: ['global-role'],
    meta: {
        roles: ['Admin', 'Manager'], // Rôles requis pour accéder à cette page
    },
})

export default {
    components: {
        getUser,
    }
}

</script>