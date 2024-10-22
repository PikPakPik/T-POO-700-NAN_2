<template>
    <div>
        <teamDetails :teamId="$route.params.teams[0]" />
    </div>
</template>

<script>
//components
import teamDetails from '~/src/components/teams/teamDetails.vue';

export default {
    components: {
        teamDetails,
    }
}

</script>