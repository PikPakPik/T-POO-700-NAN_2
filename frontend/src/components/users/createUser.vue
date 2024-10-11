<template>
    <v-container>
      <v-row justify="center" align="center" class="fill-height">
        <v-col cols="12" md="6">
          <v-card outlined>
            <v-card-title>
              <h3 class="title">Créer un nouvel utilisateur</h3>
            </v-card-title>
  
            <v-card-text>
              <v-form ref="form" v-model="valid" lazy-validation>
                <v-text-field
                  v-model="username"
                  :rules="[rules.required]"
                  label="Nom d'utilisateur"
                  required
                ></v-text-field>
  
                <v-text-field
                  v-model="email"
                  :rules="[rules.required, rules.email]"
                  label="Email"
                  required
                ></v-text-field>
  
                <v-btn :disabled="!valid" color="primary" @click="createUser">
                  Créer l'utilisateur
                </v-btn>
              </v-form>
  
              <v-alert v-if="error" type="error" class="mt-4">
                {{ error }}
              </v-alert>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script>
  //utils
  import useUsers from '~/src/utils/user/user';

  const { createUser } = useUsers();
  
  export default {
    name: 'createUser',
    data() {
      return {
        valid: false,
        username: '',
        email: '',
        error: null,
        rules: {
          required: value => !!value || 'Requis.',
          email: value => {
            const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return pattern.test(value) || 'Email non valide.';
          },
        },
      };
    },
    methods: {
      async createUser() {
        this.error = null;
        try {

            const response = await createUser(this.username, this.email);
            
            this.$router.push('/users/' + response.id);
        } catch (error) {
            console.error('Error creating user:', error);
            this.error = "Échec de la création de l'utilisateur.";
        }
      },
    },
  };
  </script>
  
  <style scoped>
  .title {
    font-weight: bold;
  }
  .v-btn {
    width: 100%;
  }
  </style>
  