<template>
  <div class="flex flex-col items-start bg-white shadow-md rounded-lg p-4 w-64">
    <div class="flex items-center justify-between w-full">
      <span class="text-black text-lg font-medium">Temps travaillé cette semaine</span>
    </div>
    <div class="flex items-center justify-between mt-4 w-full">
      <div class="text-black text-2xl font-semibold">
        {{ formattedExtraTime }}
      </div>
      <div class="p-2 flex items-center justify-center rounded-md bg-amber-50 size-24">
        <img src="@/assets/clock.svg" alt="clock" class="h-12 w-12"/>
      </div>
    </div>
  </div>
</template>

<script>
import { readWorkingTimes } from '@/src/utils/api/workingtime.ts'

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
      try {
        // TODO recup de l'userId
        const response = await readWorkingTimes(1);
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
            totalSeconds += secondsWorkedInDay;
        });

        this.extraSeconds = totalSeconds;
    }

  },
  mounted() {
    this.recupWeekHour();
  }
};
</script>