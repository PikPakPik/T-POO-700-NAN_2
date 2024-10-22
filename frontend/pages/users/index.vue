<template>
    <div>
        <getUsers />
    </div>
</template>

<script>
//components
import getUsers from '~/src/components/users/getUsers.vue';
definePageMeta({
    middleware: [
        'user',
    ],
})
export default {
    components: {
        getUsers,
    }
}

</script>