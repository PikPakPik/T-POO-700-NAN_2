<template>
  <div class="flex flex-col ml-6 mr-6 mt-10">
    <div class="flex justify-between mb-10 mt-6 flex-col md:flex-row items-center">
      <todayDate/>
        <ClockManager :userId="userId" />
    </div>
    <div class="flex gap-8 flex-col md:flex-row items-center">
      <workingTimeWeekVue />
      <extraHour />
    </div>
  </div>
</template>


<script>
//components
import ClockManager from './src/components/clockManager.vue';
import workingTimeWeekVue from './src/components/workingTimeWeek.vue';
import extraHour from './src/components/extraHour.vue';
import todayDate from './src/components/todayDate.vue';

definePageMeta({
  // middleware: ['nuxt-permissions'],
  // roles: ['Admin', 'Employee', 'Manager'],
  // permissions: ['']
})

//utils
import useUsers from '~/src/utils/user/user';

const { getUser } = useUsers();

export default {
  data() {
    return {
      currentUser: {},
      userId: localStorage.getItem('userID'),
    };
  },
  components: {
    ClockManager,
    workingTimeWeekVue,
    extraHour,
    todayDate
  }, 
  methods: {
    async getCurrentUser() {
      try {
        //getUserID from localStorage
        this.currentUser = await getUser(localStorage.getItem('userID'));
      } catch (error) {
        console.error('Failed to fetch user:', error);
      }
    },
  },
  async mounted() {
    await this.getCurrentUser();
  }
};
</script>