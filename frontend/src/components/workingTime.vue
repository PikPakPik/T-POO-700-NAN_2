<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card>
          <v-card-title>
            <h1 class="text-h5">Working Time</h1>
          </v-card-title>
          <v-card-subtitle>
            <v-alert v-if="error" type="error" class="mt-4">
              {{ error }}
            </v-alert>
            <v-alert v-if="message" type="success" class="mt-4">
              {{ message }}
            </v-alert>
          </v-card-subtitle>
          <v-card-text>
            <v-form ref="form">
              <v-row>
                <v-col cols="12" md="6">
                  <v-text-field label="Select Date start" type="datetime-local" v-model="startDate"
                    :value="formatDateTime(startDate)"></v-text-field>
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field label="Select Date end" type="datetime-local" v-model="endDate"
                    :value="formatDateTime(endDate)"></v-text-field>
                </v-col>
              </v-row>
              <v-row justify="center">
                <v-btn v-if="!workingTimeID" @click="createWorkingTime" color="primary" class="mr-2">Ajouter</v-btn>
                <div v-else>
                  <v-btn @click="updateWorkingTime" color="warning" class="mr-2">Modifier</v-btn>
                  <v-btn @click="deleteWorkingTime" color="error">Supprimer</v-btn>
                </div>
              </v-row>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { updateWorkingTime, deleteWorkingTime, createWorkingTime, readWorkingTime } from '@/src/utils/api/workingtime.ts'

export default {
  name: 'workingTime',
  data() {
    return {
      startDate: null,
      endDate: null,
      workingTime: {
        type: Object,
      },
      error: null,
      message: null
    }
  },
  props: {
    userID: {
      type: String,
      default: '',
    },
    workingTimeID: {
      type: String,
      default: '',
    },
  },

  mounted() {
    if (this.workingTimeID) {
      this.getWorkingTime();
    }
  },

  methods: {
    formatDateTime(date) {
      if (!date) return '';
      const d = new Date(date);
      const pad = (n) => (n < 10 ? '0' + n : n);
      return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
    },
    createWorkingTime() {
      createWorkingTime(this.endDate, this.startDate, this.userID)
        .then(response => {
          this.message = 'Working time ajouté';
        })
        .catch(error => {
          this.error = 'Erreur : impossible de créer le working time';
        });
    },
    updateWorkingTime() {
      updateWorkingTime(this.workingTimeID, this.endDate, this.startDate, this.userID)
        .then(response => {
          this.message = 'Working time modifié';
        })
        .catch(error => {
          this.error = 'Erreur : impossible de modifier le working time';
        });
    },
    deleteWorkingTime() {
      deleteWorkingTime(this.workingTimeID)
        .then(response => {
          this.message = 'Working time supprimé';
        })
        .catch(error => {
          this.error = 'Erreur : impossible de supprimer le working time';
        });
    },
    getWorkingTime() {
      readWorkingTime(this.userID, this.workingTimeID)
        .then(response => {
          this.workingTime = response.data;
          this.startDate = this.workingTime.start;
          this.endDate = this.workingTime.end;
        })
        .catch(error => {
          this.error = 'Erreur : impossible d\'afficher le working time';
        });
    }
  }
}
</script>

<style scoped>
.v-card-title {
  display: flex;
  justify-content: center;
}

.v-card-subtitle {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
}

.v-card-text {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
}
</style>