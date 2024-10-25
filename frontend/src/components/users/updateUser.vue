<template>
  <v-container>
    <v-btn color="primary" @click="openModal" aria-label="Modifier son profil">
      Modifier son profil
    </v-btn>

    <v-dialog v-model="showModal" max-width="600px" role="dialog" aria-labelledby="dialog-title">
      <v-card>
        <v-card-title>
          <span id="dialog-title" class="headline">Mettre à jour l'utilisateur</span>
          <v-spacer></v-spacer>
          <v-btn icon @click="showModal = false" aria-label="Fermer" class="close-button">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>

        <v-card-text>
          <v-form ref="form" v-model="valid" lazy-validation>

            <small id="username-helper" class="text-gray-500">Entrez votre nom d'utilisateur mis à jour.</small>
            <v-text-field v-model="localUser.username" label="Nom d'utilisateur" required
              aria-label="Nom d'utilisateur"></v-text-field>

            <small id="email-helper" class="text-gray-500">Entrez votre adresse mail mise à jour.</small>
            <v-text-field v-model="localUser.email" label="Email" type="email" required
              aria-label="Email"></v-text-field>

            <v-btn class="mb-3" color="secondary" @click="togglePasswordFields" aria-label="Modifier son mot de passe">
              Modifier son mot de passe
            </v-btn>

            <div v-if="showPasswordFields">
              <small id="new-password-helper" class="text-gray-500">Entrez votre nouveau mot de passe.</small>
              <v-text-field v-model="newPassword" label="Nouveau mot de passe" type="password"
                aria-label="Nouveau mot de passe"></v-text-field>

              <small id="confirm-password-helper" class="text-gray-500">Confirmez votre nouveau mot de passe.</small>
              <v-text-field v-model="confirmPassword" label="Confirmer le mot de passe" type="password"
                aria-label="Confirmer le mot de passe"></v-text-field>
            </div>

            <v-alert v-if="error" type="error" class="mt-4" role="alert">
              {{ error }}
            </v-alert>
          </v-form>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="showModal = false" aria-label="Annuler">
            Annuler
          </v-btn>
          <v-btn color="primary" @click="updateUser" :disabled="!valid" aria-label="Sauvegarder">
            Sauvegarder
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<style scoped>
.close-button {
  position: absolute;
  top: 10px;
  right: 10px;
}
</style>

<script>
//utils
import { mePutUser } from '~/src/utils/api/me';

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
      localUser: { ...this.user },
      showPasswordFields: false,
      newPassword: '',
      confirmPassword: ''
    };
  },
  methods: {
    openModal() {
      this.localUser = { ...this.user };
      this.showModal = true;
    },
    togglePasswordFields() {
      this.showPasswordFields = !this.showPasswordFields;
    },
    async updateUser() {
      this.error = null;
      try {
        if (this.newPassword !== '' && this.confirmPassword !== '') {
          if (this.newPassword !== this.confirmPassword) {
            this.error = "Les mots de passe ne correspondent pas.";
            return;
          }
          // Appel API pour mettre à jour l'utilisateur
          await mePutUser(this.user.id, this.localUser.username, this.localUser.email, this.newPassword);
        } else {
          // Appel API pour mettre à jour l'utilisateur
          await mePutUser(this.user.id, this.localUser.username, this.localUser.email);
        }
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