<template>
    <v-container>
      <v-btn color="primary" @click="openModal">
        Modifier son profil
      </v-btn>
  
      <v-dialog v-model="showModal" max-width="600px">
        <v-card>
          <v-card-title>
            <span class="headline">Mettre à jour l'utilisateur</span>
            <v-spacer></v-spacer>
            <v-btn icon @click="showModal = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </v-card-title>
  
          <v-card-text>
            <v-form ref="form" v-model="valid" lazy-validation>
              <v-text-field
                v-model="localUser.username"
                label="Nom d'utilisateur"
                required
              ></v-text-field>
  
              <v-text-field
                v-model="localUser.email"
                label="Email"
                type="email"
                required
              ></v-text-field>
              
              <v-alert v-if="error" type="error" class="mt-4">
                {{ error }}
              </v-alert>
            </v-form>
          </v-card-text>
  
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="showModal = false">
              Annuler
            </v-btn>
            <v-btn color="primary" @click="updateUser" :disabled="!valid">
              Sauvegarder
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-container>
  </template>
  
  <script>
  //utils
  import useUsers from '~/src/utils/user/user';

  const { updateUser } = useUsers();
  
  export default {
    name: 'updateUser',
    props: {
      user: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        showModal: false,
        valid: false,
        error: null,
        localUser: { ...this.user }
      };
    },
    methods: {
      openModal() {
        this.localUser = { ...this.user };
        this.showModal = true;
      },
      async updateUser() {
        this.error = null;
        try {
          // Appel API pour mettre à jour l'utilisateur
          await updateUser(this.user.id, this.localUser.username, this.localUser.email);
          this.showModal = false;
          window.location.reload(); 
        } catch (error) {
          console.error('Error updating user:', error);
          this.error = "Échec de la mise à jour de l'utilisateur.";
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .headline {
    font-weight: bold;
    color: #333;
  }
  </style>