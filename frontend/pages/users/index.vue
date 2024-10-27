<template>
    <div>
        <getUsers />
    </div>
</template>

<script>
//components
import getUsers from '~/src/components/users/getUsers.vue';

definePageMeta({
    middleware: ['global-role'],
    meta: {
        roles: ['Admin', 'Manager'],
    },
})

export default {
    components: {
        getUsers,
    }
}

</script>