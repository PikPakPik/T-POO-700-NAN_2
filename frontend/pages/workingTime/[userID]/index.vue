<template>
    <workingTime :userID="$route.params.userID" />
</template>

<script>
import workingTime from '@/src/components/workingTime.vue';
export default {
    components: {
        workingTime
    }
}
</script>