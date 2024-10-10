<template>
    <workingTimes :userID="$route.params.userID" />
</template>

<script>
import workingTimes from '@/src/components/workingTimes.vue';
export default {
    components: {
        workingTimes
    }
}
</script>