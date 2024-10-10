<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card>
          <v-card-title>
            <h1 class="text-h5">Working Time</h1>
          </v-card-title>
          <v-card-subtitle>
            <h2>User ID: {{ userID }}</h2>
            <h3>Working Time ID: {{ workingTimeID }}</h3>
          </v-card-subtitle>
          <v-card-text>
            <v-form ref="form">
              <v-row>
                <v-col cols="12" md="6">
                  <v-text-field label="Select Date start" type="datetime-local" v-model="startDate"></v-text-field>
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field label="Select Date end" type="datetime-local" v-model="endDate"></v-text-field>
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
import { updateWorkingTime, deleteWorkingTime, createWorkingTime } from '@/src/utils/api/workingtime.ts'

export default {
  name: 'workingTime',
  data() {
    return {
      startDate: null,
      endDate: null,
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

  methods: {
    createWorkingTime() {
      createWorkingTime(this.endDate, this.startDate, this.userID)
        .then(response => {
          console.log('Working time created:', response);
        })
        .catch(error => {
          console.error('Error creating working time:', error);
        });
    },
    updateWorkingTime() {
      updateWorkingTime(this.workingTimeID, this.endDate, this.startDate, this.userID)
        .then(response => {
          console.log('Working time updated:', response);
        })
        .catch(error => {
          console.error('Error updating working time:', error);
        });
    },
    deleteWorkingTime() {
      deleteWorkingTime(this.workingTimeID)
        .then(response => {
          console.log('Working time deleted:', response);
        })
        .catch(error => {
          console.error('Error deleting working time:', error);
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