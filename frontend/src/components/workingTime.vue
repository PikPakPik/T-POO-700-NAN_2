<template>
  <v-card class="mx-auto my-12" max-width="600">
    <v-toolbar flat class="custom-toolbar">
      <v-toolbar-title v-if="workingTimeID > 0" class="white--text">Modifier le Working Time</v-toolbar-title>
      <v-toolbar-title v-else class="white--text">Ajouter un Working Time</v-toolbar-title>
      <v-btn icon @click="$emit('close')">
        <v-icon class="white--text">mdi-close</v-icon>
      </v-btn>
    </v-toolbar>
    <v-divider></v-divider>
    <v-card-text>
      <!-- Updating form working time -->
      <v-form ref="form">
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field label="Date de début" type="datetime-local" v-model="startDate" :value="startDate"
              outlined></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field label="Date de fin" type="datetime-local" v-model="endDate" :value="endDate"
              outlined></v-text-field>
          </v-col>
        </v-row>
      </v-form>
    </v-card-text>
    <v-divider></v-divider>
    <v-card-actions>
      <v-spacer></v-spacer>
      <v-btn color="blue darken-1" text @click="save">
        <v-icon left>mdi-content-save</v-icon> Enregistrer
      </v-btn>
    </v-card-actions>
  </v-card>
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
    }
  },
  props: {
    userID: {
      type: String,
      default: '',
    },
    workingTimeID: {
      type: Number,
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
      return moment(date).format('YYYY-MM-DD HH:mm');
    },
    save() {
      if (this.workingTimeID) {
        this.updateWorkingTime();
      } else {
        this.createWorkingTime();
      }
    },
    createWorkingTime() {
      createWorkingTime(this.endDate, this.startDate, this.userID)
        .then(response => {
          this.$emit('created', 'Working time ajouté');
        })
        .catch(error => {
          this.$emit('error', 'Erreur : impossible de créer le working time');
        }).finally(() => {
          this.$emit('close');
        });
    },
    updateWorkingTime() {
      updateWorkingTime(this.workingTimeID, this.endDate, this.startDate, this.userID)
        .then(response => {
          this.$emit('updated', 'Working time modifié');
        })
        .catch(error => {
          this.$emit('error', 'Erreur : impossible de modifier le working time');
        }).finally(() => {
          this.$emit('close');
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
          this.$emit('error', 'Erreur : impossible d\'afficher le working time');
        });
    }
  }
}
</script>

<style scoped>
.v-card {
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.custom-toolbar {
  background-color: #FFC107;
  /* Amber color */
  border-top-left-radius: 12px;
  border-top-right-radius: 12px;
  border-radius: inherit;
}

.v-card-actions {
  justify-content: flex-end;
}
</style>