<template>
    <workingTime :workingTimeID="$route.params.workingTimeID" :userID="$route.params.userID" />
</template>

<script>
import workingTime from '@/src/components/workingTime.vue';

definePageMeta({
    middleware: ["manager"]
})

export default {
    components: {
        workingTime
    }
}
</script>