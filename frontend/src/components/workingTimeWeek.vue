<template>
  <dashboardCard :title="'Temps travaillé'" :subTitle="'cette semaine'" :formattedExtraTime="formattedExtraTime"
    :icon="clock" data-title="Horloge temps travaillé" data-intro="Temps travaillé cette semaine." />
</template>

<script>
import isoweek from 'dayjs/plugin/isoWeek';
import dayjs from 'dayjs';
//utils
import { readWorkingTimes } from '@/src/utils/api/workingtime.ts'
import useUsers from '../utils/user/user';
//cards
import dashboardCard from './cards/dashboardCard.vue';

dayjs.extend(isoweek);
const { getUser } = useUsers();

export default {
  data() {
    return {
      workingTimes: [],
      extraSeconds: 0,
    };
  },
  computed: {
    formattedExtraTime() {
      const hours = Math.floor(this.extraSeconds / 3600);
      const minutes = Math.floor((this.extraSeconds % 3600) / 60);
      const seconds = this.extraSeconds % 60;
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
  },
  methods: {
    async recupWeekHour() {
      const startOfWeek = dayjs().isoWeekday(1).startOf('day');
      const endOfWeek = dayjs().isoWeekday(7).endOf('day');
      try {
        const user = await getUser(localStorage.getItem('userID'));
        const response = await readWorkingTimes(user.id, startOfWeek.toISOString(), endOfWeek.toISOString());
        if (response && response.data) {
          this.workingTimes = response.data;
          this.calculateWeekHours();
        }
      } catch (error) {
        console.error('Erreur lors de la récupération des workingTimes :', error);
      }
    },
    calculateWeekHours() {
      let totalSeconds = 0;
      const workByDay = {};

      this.workingTimes.forEach(workingTime => {
        const startTime = dayjs(workingTime.start);
        const endTime = dayjs(workingTime.end);

        const dayKey = startTime.toISOString().split('T')[0];
        const secondsWorked = endTime.diff(startTime, 'seconds');

        if (!workByDay[dayKey]) {
          workByDay[dayKey] = 0;
        }
        workByDay[dayKey] += secondsWorked;
      });


      Object.keys(workByDay).forEach(dayKey => {
        const secondsWorkedInDay = workByDay[dayKey];
        totalSeconds += secondsWorkedInDay;
      });

      this.extraSeconds = totalSeconds;
    }

  },
  mounted() {
    this.recupWeekHour();
  },
  components: {
    dashboardCard
  }
};
</script>
