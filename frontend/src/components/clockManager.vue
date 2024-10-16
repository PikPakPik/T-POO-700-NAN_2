<template>
  <div class="flex flex-col items-start bg-white shadow-md rounded-lg p-4">
    <div class="flex items-center space-x-4">
      <span class="text-black text-lg font-medium">Démarrer le pointage</span>
      <button 
        @click="togglePlay" 
        class="bg-amber-400 p-3 flex items-center justify-center rounded-md"
      >
        <img v-if="!isPlaying" src="@/assets/bouton-jouer.png" alt="Play Icon" class="h-6 w-6" />
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
      isPlaying: false,
      hasStarted: false,
      timeElapsed: 0,
      timer: null,
      isDisabled: false,
    };
  },
  computed: {
    formattedTime() {
      const hours = Math.floor(this.timeElapsed / 3600);
      const minutes = Math.floor((this.timeElapsed % 3600) / 60);
      const seconds = this.timeElapsed % 60;
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
  },
  methods: {
    async togglePlay() {
      if (this.isPlaying) {
        
        clearInterval(this.timer);
        this.timer = null;
        this.isPlaying = false;
        this.saveToLocalStorage();
        await this.submitWork();  

      } else {
        
        if (!this.hasStarted) {
          this.hasStarted = true;
        }
        await this.startWorking();  
        this.timer = setInterval(() => {
          this.timeElapsed++;
          this.saveToLocalStorage();
        }, 1000);
        this.isPlaying = true;
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
      this.isPlaying = false;
      try {
        const response = await this.clockApiService.endWorking(this.userId, this.endDateTime);
      } catch (error) {
        console.error('Erreur lors de la fin du travail :', error);
      }
    },

    saveToLocalStorage() {
      const data = {
        timeElapsed: this.timeElapsed,
        isPlaying: this.isPlaying,
        hasStarted: this.hasStarted,
        startDateTime: this.startDateTime,
      };
      localStorage.setItem('clockData', JSON.stringify(data));
    },

    loadFromLocalStorage() {
      const savedData = localStorage.getItem('clockData');
      if (savedData) {
        const parsedData = JSON.parse(savedData);
        this.timeElapsed = parsedData.timeElapsed;
        this.isPlaying = parsedData.isPlaying;
        this.hasStarted = parsedData.hasStarted;
        this.startDateTime = parsedData.startDateTime;

        if (this.isPlaying) {
          this.timer = setInterval(() => {
            this.timeElapsed++;
            this.saveToLocalStorage();
          }, 1000);
        }
      }
    },

    clearLocalStorage() {
      localStorage.removeItem('clockData');
    }
  },

  mounted() {
    this.loadFromLocalStorage();
  }
};
</script>
