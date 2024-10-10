<template>
  <v-container>
    <v-row justify="center" align="center" class="fill-height">
      <v-col cols="12" md="8">
        <v-card outlined flex="flex">
          <v-card-title>
            <h3 class="user-title">{{ userData ? userData.username : 'Chargement de l’utilisateur...' }}</h3>
          </v-card-title>

          <v-card-text>
            <v-alert v-if="error" type="error" class="mt-4">
              {{ error }}
            </v-alert>

            <v-alert v-else-if="loading" type="info" class="mt-4">
              Chargement en cours...
            </v-alert>

            <div v-else-if="userData" class="user-details">
              <p><strong>Nom d'utilisateur:</strong> {{ userData.username }}</p>
              <p><strong>Email:</strong> {{ userData.email }}</p>
            </div>
          </v-card-text>
          <v-card-actions class="justify-end">
            <update-user :user="userData" />
            <delete-user :user="userData" />
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
//components
import updateUser from '~/src/components/users/updateUser.vue';
import deleteUser from '~/src/components/users/deleteUser.vue';

//utils
import { UsersApi } from '~/src/utils/api/users';

const userApi = new UsersApi();

export default {
  name: 'getUser',
  components: {
    updateUser,
    deleteUser
  },
  data() {
    return {
      userData: null,
      error: null,
      loading: true,
    };
  },
  mounted() {
    this.fetchUserData();
  },
  methods: {
    async fetchUserData() {
      try {
        const userId = this.$route.params.users[0];
        const response = await userApi.getUserByID(userId);
        this.userData = response.data.data;
        this.loading = false;
      } catch (error) {
        this.error = 'Échec du chargement des données utilisateur';
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.user-title {
  font-weight: bold;
  color: #333;
}
.user-details {
  margin-top: 10px;
}
</style>