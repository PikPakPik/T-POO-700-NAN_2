<template>
    <div>
        <teamDetails :teamId="$route.params.teams[0]" />
    </div>
</template>

<script>
//components
import teamDetails from '~/src/components/teams/teamDetails.vue';
definePageMeta({
    middleware: [
        'user',
    ],
})
export default {
    components: {
        teamDetails,
    }
}

</script>