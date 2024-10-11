<template>
  <div class="clock-manager">
  
    <h2>Pointage du {{ formattedDate }}</h2>

    <button
     @click="toggleClock"
      :class="clockIn ? 'btn-green' : lastEndWork === formattedDate ? 'btn-grey' : 'btn-red'"
      class="clock-btn"
      :disabled="lastEndWork === formattedDate"
    >
      {{ clockIn ? 'Travail en cours' : lastEndWork === formattedDate ? 'Travail déjà terminé aujourd\'hui' : 'Commencer le travail' }}
    </button>

    
    <div class="time-info" v-if="clockIn && !endDateTime">
      <p>Début du travail à : {{ startTime }}</p>
    </div>
    <div class="time-info" v-if="!clockIn && endDateTime">
      <p>Début du travail à : {{ startTime }}</p>
      <p>Travail terminé à : {{ endTime }}</p>
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
      clockIn: false,
      lastEndWork: null,
      clockApiService: new ClockApi()
    };
  },
  computed: {
    formattedDate() {
      if (this.startDateTime) {
        return new Date(this.startDateTime).toLocaleDateString('fr-FR')
      }
      return new Date().toLocaleDateString('fr-FR')
    },
    startTime() {
      if (this.startDateTime) {
        return new Date(this.startDateTime).toLocaleTimeString('fr-FR')
      }
      return null;
    },
    endTime() {
      if (this.endDateTime) {
        return new Date(this.endDateTime).toLocaleTimeString('fr-FR')
      }
      return null;
  }
  },
  methods: {

    toggleClock() {
      if (this.clockIn) {
        this.stopWorking();
      } else {
        this.startWorking();
      }
    },

    async startWorking() {
      const now = new Date();
      this.startDateTime = now.toISOString();
      this.endDateTime = null;
      try {
        const response = await this.clockApiService.startWorking(this.userId, this.startDateTime);
        this.clockIn = true;
      } catch (error) {
        console.error('Erreur lors du début du travail :', error);
      }
    },

    async stopWorking() {
      const now = new Date();
      this.endDateTime = now.toISOString();
      try {
        const response = await this.clockApiService.endWorking(this.userId, this.endDateTime);
        this.clockIn = false;
        this.lastEndWork = this.formattedDate; 
      } catch (error) {
        console.error('Erreur lors de la fin du travail :', error);
      }
    }

  }
};
</script>

<style scoped>
.clock-manager {
  text-align: center;
  margin: 20px;
}

.clock-btn {
  padding: 15px 30px;
  font-size: 1rem;
  border: none;
  border-radius: 5px;
  color: white;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-green {
  background-color: green;
}

.btn-red {
  background-color: red;
}

.clock-btn:hover {
  opacity: 0.9;
}

.time-info p {
  font-size: 1.2rem;
  margin-top: 15px;
}

.btn-grey {
  background-color: grey;
}

.clock-btn:disabled {
  cursor: not-allowed;
  opacity: 0.6; 
}
</style>
