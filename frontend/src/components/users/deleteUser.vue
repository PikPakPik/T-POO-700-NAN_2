<template>
    <v-container>
      <!-- Bouton pour ouvrir la modale de confirmation de suppression -->
      <v-btn color="red darken-2" @click="showDeleteModal = true">
        Supprimer
      </v-btn>
  
      <!-- Modale d'avertissement de suppression -->
      <v-dialog v-model="showDeleteModal" max-width="500px">
        <v-card>
          <v-card-title class="headline red--text">
            Confirmation de suppression
          </v-card-title>
  
          <v-card-text>
            <p>Êtes-vous sûr de vouloir supprimer cet utilisateur ?</p>
            <v-alert type="warning">
              Cette action est irréversible !
            </v-alert>
          </v-card-text>
  
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn text @click="showDeleteModal = false">
              Annuler
            </v-btn>
            <v-btn color="red darken-2" @click="deleteUser">
              Supprimer
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-container>
  </template>
  
  <script>
  //utils
  import useUsers from '~/src/utils/user/user';

  const { deleteUser } = useUsers();
  
  export default {
    name: 'deleteUser',
    props: {
      user: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        showDeleteModal: false,
        error: null
      };
    },
    methods: {
      async deleteUser() {
        this.error = null;
        try {
          const userId = this.user.id;
          await deleteUser(userId);
          this.showDeleteModal = false;
          this.$router.push('/users');
        } catch (error) {
          console.error('Error deleting user:', error);
          this.error = "Échec de la suppression de l'utilisateur.";
        }
      }
    }
  };
  </script>
  
  <style scoped>
  .headline {
    font-weight: bold;
  }
  .red--text {
    color: #f44336 !important;
  }
  </style>
