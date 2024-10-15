<template>
  <v-container>
    <v-btn color="red darken-2" @click="showDeleteModal = true" aria-label="Supprimer l'utilisateur">
      Supprimer
    </v-btn>

    <v-dialog v-model="showDeleteModal" max-width="500px" aria-labelledby="delete-dialog-title" aria-describedby="delete-dialog-description" role="dialog">
      <v-card>
        <v-card-title class="headline red--text" id="delete-dialog-title">
          Confirmation de suppression
        </v-card-title>

        <v-card-text id="delete-dialog-description">
          <p>Êtes-vous sûr de vouloir supprimer cet utilisateur ?</p>
          <v-alert type="warning" role="alert">
            Cette action est irréversible !
          </v-alert>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="showDeleteModal = false" aria-label="Annuler la suppression">
            Annuler
          </v-btn>
          <v-btn color="red darken-2" @click="deleteUser" aria-label="Confirmer la suppression">
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
