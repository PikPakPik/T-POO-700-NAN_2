<template>
  <div class="flex flex-col items-start bg-white shadow-md rounded-lg p-4">
    <div class="flex items-center space-x-4">
      <span class="text-black text-lg font-medium">Démarrer le pointage</span>
      <button 
        @click="togglePlay" 
        class="bg-amber-400 p-3 flex items-center justify-center rounded-md"
      >
        <img v-if="!chronoStore.isPlaying" src="@/assets/bouton-jouer.png" alt="Play Icon" class="h-6 w-6" />
        <img v-else src="@/assets/bouton-pause.png" alt="Pause Icon" class="h-6 w-6" />
      </button>
    </div>

    <div v-if="hasStarted" class="mt-3 text-black text-lg font-medium text-2xl">
      {{ formattedTime }}
    </div>
  </div>
</template>

<script>
import ClockApi from '~/src/utils/api/clock';
import { useChronoStore } from '@/stores/chronoStore';

export default {
  props: {
    userId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      startDateTime: null,
      endDateTime: null,
      clockApiService: new ClockApi(),
      hasStarted: false,
      timer: null,
      isPlaying: false,
      isDisabled: false,
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
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
  },
  methods: {
    async togglePlay() {
      if (this.chronoStore.getIsPlaying) {
        
        clearInterval(this.timer);
        this.timer = null;
        this.chronoStore.updateIsPlaying(false);
        this.saveToLocalStorage();
        await this.submitWork();  

      } else {
        
        if (!this.hasStarted) {
          this.hasStarted = true;
        }
        await this.startWorking();  
        this.timer = setInterval(() => {
          const updatedTime = this.chronoStore.getTimeElapsed + 1;
          this.chronoStore.updateTimeElapsed(updatedTime);
          this.saveToLocalStorage();
        }, 1000);
        this.chronoStore.updateIsPlaying(true);
        this.saveToLocalStorage();
      }
    },

    beforeDestroy() {
      clearInterval(this.timer);
    },

    async startWorking() {

      const now = new Date();
      this.startDateTime = now.toISOString();
      try {
        const response = await this.clockApiService.startWorking(this.userId, this.startDateTime);
      } catch (error) {
        console.error('Erreur lors du début du travail :', error);
      }
    },

    async submitWork() {

      const now = new Date();
      this.endDateTime = now.toISOString();
      clearInterval(this.timer);
      this.chronoStore.updateIsPlaying(false);
      try {
        const response = await this.clockApiService.endWorking(this.userId, this.endDateTime);
      } catch (error) {
        console.error('Erreur lors de la fin du travail :', error);
      }
    },

    saveToLocalStorage() {
      const data = {
        timeElapsed: this.chronoStore.getTimeElapsed,
        isPlaying : this.chronoStore.getIsPlaying,
        hasStarted: this.hasStarted,
        startDateTime: this.startDateTime,
      };
      localStorage.setItem('clockData', JSON.stringify(data));
    },

    loadFromLocalStorage() {
      const savedData = localStorage.getItem('clockData');
      if (savedData) {
        const parsedData = JSON.parse(savedData);
        this.chronoStore.updateTimeElapsed(parsedData.timeElapsed);
        this.chronoStore.updateIsPlaying(parsedData.isPlaying);
        this.hasStarted = parsedData.hasStarted;
        this.startDateTime = parsedData.startDateTime;

        if (this.chronoStore.getIsPlaying) {
          this.timer = setInterval(() => {
            const updatedTime = this.chronoStore.getTimeElapsed + 1;
            this.chronoStore.updateTimeElapsed(updatedTime);
            this.saveToLocalStorage();
          }, 1000);
        }
      }
    },
    clearLocalStorage() {
      localStorage.removeItem('clockData');
    },
  },

  mounted() {
    this.loadFromLocalStorage();
  }
};
</script>
