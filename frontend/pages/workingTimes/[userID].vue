<template>
    <workingTimes :userID="$route.params.userID" />
</template>

<script>
import workingTimes from '@/src/components/workingTimes.vue';

definePageMeta({
    middleware: ["user"]
})

export default {
    components: {
        workingTimes
    }
}
</script>