<template>
  <div class=" bg-white shadow-md rounded-lg px-8 py-6 w-80 index-intro" data-title="Pointeur"
    data-intro="Voici votre pointeur">>
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
        data-intro="Bouton pour déclancher le pointage au premier click et l'arrêter au second click.">
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

export default {
  props: {
    userId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      clockApiService: new ClockApi(),
      hasStarted: false,
      timer: null,
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
        clearInterval(this.timer);
        this.timer = null;
        this.chronoStore.reset();
        if (this.hasStarted) {
          this.hasStarted = false;
        }
      } else {
        if (!this.hasStarted) {
          this.hasStarted = true;
        }
        this.startTimer();
      }
      this.clockApiService.clockInOrOut(this.userId);
    },

    beforeDestroy() {
      clearInterval(this.timer);
    },

    async getClockStatus() {
      try {
        const response = await this.clockApiService.getClock(this.userId);
        const { status, time } = response.data[0];
        const startTime = new Date(time);
        const now = new Date();
        const utcOffset = now.getTimezoneOffset() * 60000; // décalage UTC en millisecondes
        const localStartTime = new Date(startTime.getTime() - utcOffset); // convertir l'heure de début en heure locale
        const timeDifference = Math.floor((now - localStartTime) / 1000);
        this.chronoStore.updateTimeElapsed(timeDifference);
        this.hasStarted = status;
        if (status) {
          this.startTimer();
        }
      } catch (error) {
        console.error('Erreur lors de la récupération de l\'état du chronomètre :', error);
      }
    },

    startTimer() {
      console.log('startTimer');
      this.timer = setInterval(() => {
        const updatedTime = this.chronoStore.getTimeElapsed + 1;
        this.chronoStore.updateTimeElapsed(updatedTime);
      }, 1000);
      this.chronoStore.updateIsPlaying(true);
    },
  },

  mounted() {
    this.getClockStatus();
  }
};
</script>
