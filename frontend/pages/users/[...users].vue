<template>
    <div>
        <getUser />
    </div>
</template>

<script>
//components
import getUser from '~/src/components/users/getUser.vue';
definePageMeta({
    middleware: [
        'user',
    ],
})
export default {
    components: {
        getUser,
    }
}

</script>