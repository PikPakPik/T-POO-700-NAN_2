<template>
  <dashboardCard :title="'Heure supplémentaires'" :subTitle="'cette semaine'" :formattedExtraTime="formattedExtraTime"
    data-title="Horloge temps supplémentaires" data-intro="Heures supplémentaires acquis cette semaine." />
</template>


<script>
import dayjs from 'dayjs';
import isoweek from 'dayjs/plugin/isoWeek';
//utils
import { meWorkingTimesDated } from '@/src/utils/api/me.ts'
//cards
import dashboardCard from './cards/dashboardCard.vue';

dayjs.extend(isoweek);


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
    async recupExtraHour() {
      try {
        const startOfWeek = dayjs().isoWeekday(1).startOf('day');
        const endOfWeek = dayjs().isoWeekday(7).endOf('day');
        const response = await meWorkingTimesDated(startOfWeek.toISOString(), endOfWeek.toISOString());
        if (response && response.data) {
          this.workingTimes = response.data;
          this.calculateExtraHours();
        }
      } catch (error) {
        console.error('Erreur lors de la récupération des working times :', error);
      }
    },
    calculateExtraHours() {
      let totalExtraSeconds = 0;
      const workByDay = {};

      this.workingTimes.forEach(workingTime => {
        const startTime = new Date(workingTime.start);
        const endTime = new Date(workingTime.end);

        const dayKey = startTime.toISOString().split('T')[0];
        const secondsWorked = (endTime - startTime) / 1000;


        if (!workByDay[dayKey]) {
          workByDay[dayKey] = 0;
        }
        workByDay[dayKey] += secondsWorked;
      });


      Object.keys(workByDay).forEach(dayKey => {
        const secondsWorkedInDay = workByDay[dayKey];
        const sevenHoursInSeconds = 7 * 3600;


        if (secondsWorkedInDay > sevenHoursInSeconds) {
          totalExtraSeconds += secondsWorkedInDay - sevenHoursInSeconds;
        }
      });

      this.extraSeconds = totalExtraSeconds;
    }

  },
  mounted() {
    this.recupExtraHour();
  },
  components: {
    dashboardCard
  }
};
</script>
