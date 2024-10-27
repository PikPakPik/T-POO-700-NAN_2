<template>
  <div class=" bg-white shadow-md rounded-lg px-8 py-6 w-80 index-intro" data-title="Pointeur"
    data-intro="Voici votre pointeur">
    <div class="flex items-center justify-center gap-4">
      <div v-if="hasStarted" class="flex flex-col w-full text-center">
        <h3 class="text-black text-lg font-medium">
          Arrêter le pointage
        </h3>
        <span class="text-black text-lg font-medium">
          {{ formattedTime }}
        </span>
      </div>
      <span v-else class="text-black text-lg font-medium w-full">Démarrer le pointage</span>
      <button @click="togglePlay" class="bg-amber-400 p-4 flex items-center justify-center rounded-lg index-intro"
        data-title="Bouton on/off"
        data-intro="Bouton pour déclencher le pointage au premier click et l'arrêter au second click.">

        <svg v-if="chronoStore.getIsPlaying" width="30" height="30" viewBox="0 0 45 45" fill="none"
          xmlns="http://www.w3.org/2000/svg">
          <rect width="45" height="45" rx="4" fill="black" />
        </svg>

        <svg v-else width="27" height="31" viewBox="0 0 27 31" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            d="M25 12.0359C27.6667 13.5755 27.6667 17.4245 25 18.9641L6.25 29.7894C3.58333 31.329 0.249998 29.4045 0.249999 26.3253L0.25 4.67468C0.25 1.59548 3.58333 -0.329021 6.25 1.21058L25 12.0359Z"
            fill="black" />
        </svg>
      </button>
    </div>
  </div>
</template>

<script>
import ClockApi from '~/src/utils/api/clock';
import {
  useChronoStore
} from '@/stores/chronoStore';
import { meClockInOrOut, meGetClock } from '~/src/utils/api/me';
import dayjs from 'dayjs';
import { startInterval, stopInterval } from '~/src/utils/intervalManager';

export default {
  data() {
    return {
      clockApiService: new ClockApi(),
      hasStarted: false,
    };
  },
  computed: {
    chronoStore() {
      return useChronoStore();
    },
    formattedTime() {
      const hours = Math.floor(this.chronoStore.getTimeElapsed / 3600);
      const minutes = Math.floor((this.chronoStore.getTimeElapsed % 3600) / 60);
      const seconds = this.chronoStore.getTimeElapsed % 60;
      return `${hours.toString().padStart(2, '0')}H ${minutes.toString().padStart(2, '0')}m ${seconds.toString().padStart(2, '0')}s`;
    }
  },
  methods: {
    togglePlay() {
      if (this.chronoStore.getIsPlaying) {
        stopInterval();
        this.chronoStore.reset();
        this.formattedTime = '00H 00m 00s';
        this.hasStarted = false;
      } else {
        this.hasStarted = true;
        startInterval(this.updateTime, 1000);
      }
      meClockInOrOut();
    },

    updateTime() {
      const updatedTime = this.chronoStore.getTimeElapsed + 1;
      this.chronoStore.updateTimeElapsed(updatedTime);
    },

    beforeDestroy() {
      stopInterval();
    },

    async getClockStatus() {
      try {
        const response = await meGetClock();
        if (response && response.clock) {
          const { status, time } = response.clock;
          const startTime = dayjs(time);
          const now = dayjs();
          const timeDifference = now.diff(startTime, 'second');
          this.chronoStore.updateTimeElapsed(timeDifference);
          this.hasStarted = status;
          if (status) {
            startInterval(this.updateTime, 1000);
          }
        }
      } catch (error) {
        console.error('Erreur lors de la récupération de l\'état du chronomètre :', error);
      }
    },
  },
  mounted() {
    this.getClockStatus();
  },
  activated() {
    if (this.hasStarted) {
      startInterval(this.updateTime, 1000);
    }
  },
  deactivated() {
    stopInterval();
  }
};
</script>

