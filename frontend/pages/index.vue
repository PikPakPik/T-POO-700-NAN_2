<template>
  <div class="flex flex-col ml-6 mr-6 mt-10">
    <div class="flex justify-between mb-10 mt-6 flex-col md:flex-row items-center">
      <todayDate/>
      <template v-if="isTeamStarted">
        <span>je suis là</span>
      </template>
      <template v-else>
        <ClockManager :aria-disabled="isTeamStarted" :id="1"/>
      </template>
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
import useTeams from '~/src/utils/team/team';
import useUsers from '~/src/utils/user/user';

const { showTeam } = useTeams();
const { getUser } = useUsers();

export default {
  data() {
    return {
      currentUser: {},
      isTeamStarted: false,
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
        this.currentUser = await getUser(1); // to change dynamic blabla
        this.teamStarted(); // Ensure teamStarted is called after currentUser is set
      } catch (error) {
        console.error('Failed to fetch user:', error);
      }
    },
    async teamStarted() {
      const user = this.currentUser;
        const teams = user.teams;
        for (let i = 0; i < teams.length; i++) {
          const team = teams[i];
          const teamClock = await showTeam(team.id);
          console.log('teamClock:', teamClock);
          if (teamClock) {
            this.isTeamStarted = true;
            break; // Exit loop if a teamClock is found
          }
      }
    },
  },
  async mounted() {
    await this.getCurrentUser();
  }
};
</script>