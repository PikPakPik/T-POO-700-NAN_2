<template>
    <div>
        <getTeams />
    </div>
</template>

<script>
//components
import getTeams from '~/src/components/teams/getTeams.vue';
definePageMeta({
    middleware: [
        'user',
    ],
})
export default {
    components: {
        getTeams,
    }
}

</script>