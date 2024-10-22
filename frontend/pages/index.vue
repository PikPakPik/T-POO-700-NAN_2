<template>
  <div class="flex flex-col ml-6 mr-6 mt-10">
    <div class="flex justify-between mb-10 mt-6 flex-col md:flex-row items-center">
      <todayDate />
      <ClockManager :userId="1" />
    </div>
    <div class="flex gap-8 flex-col md:flex-row items-center">
      <workingTimeWeekVue />
      <extraHour />
    </div>
  </div>
</template>


<script>
import ClockManager from './src/components/clockManager.vue';
import workingTimeWeekVue from './src/components/workingTimeWeek.vue';
import extraHour from './src/components/extraHour.vue';
import todayDate from './src/components/todayDate.vue';

definePageMeta({
  // middleware: ['nuxt-permissions'],
  // roles: ['Admin', 'Employee', 'Manager'],
  // permissions: ['']
})

export default {
  components: {
    ClockManager,
    workingTimeWeekVue,
    extraHour,
    todayDate
  }
};
</script>