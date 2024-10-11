<template>
  <div>
    <ClockManager :userId=1 />
  </div>
</template>

<script>
import ClockManager from './src/components/clockManager.vue';

export default {
  components: {
    ClockManager
  }
};
</script>