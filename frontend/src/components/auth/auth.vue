<template>
    <div class="bg-white dark:bg-gray-900">
        <div class="flex justify-center h-screen">
            <div class="hidden bg-cover lg:block lg:w-full" :style="{ backgroundImage: `url(${gotham})` }">
                <div class="flex items-center h-full px-20 bg-gray-900 bg-opacity-40">
                    <div>
                        <h2 class="text-2xl font-bold text-white sm:text-3xl">GOTHAM TIME MANAGER</h2>
                        <p class="max-w-xl mt-3 text-gray-300">
                            Venez pointer vos heures de travail en toute simplicité pour chasser les méchants et sauver gotham city.
                        </p>
                    </div>
                </div>
            </div>

            <v-container class="flex items-center">
                <v-card class="flex-1">
                    <v-card-title class="text-center">
                        <v-avatar class="mx-auto">
                            <img :src="logo" alt="Logo" class="w-auto h-7 sm:h-8">
                        </v-avatar>
                        <v-card-subtitle class="mt-3 text-black dark:text-gray-300">
                            <span v-if="!isRegistering">Connectez-vous pour accéder à votre compte</span>
                            <span v-else>Inscription</span>
                        </v-card-subtitle>
                    </v-card-title>

                    <v-card-text class="mt-8" v-if="!isRegistering">
                        <v-form>
                            <v-text-field
                                label="Adresse Mail"
                                name="email"
                                id="email"
                                class="text-xs"
                                outlined
                                :rules="[rules.required, rules.email]"
                                required
                            ></v-text-field>

                            <v-text-field
                                label="Mot de passe"
                                name="password"
                                id="password"
                                class="text-xs"
                                type="password"
                                outlined
                                :rules="[rules.required]"
                            ></v-text-field>

                            <v-btn class="mt-6 w-full" color="blue" @click="login">
                                Connexion
                            </v-btn>
                        </v-form>

                        <v-card-actions class="mt-6 text-sm text-center text-gray-400">
                            Pas encore de compte ? 
                            <v-btn text color="blue" @click="toggleForm">Inscription</v-btn>
                        </v-card-actions>
                    </v-card-text>

                    <v-card-text class="mt-8" v-else>
                        <v-form>
                            <v-text-field
                                label="Nom d'utilisateur"
                                name="username"
                                id="username"
                                v-model="username"
                                class="text-xs"
                                :rules="[rules.required]"
                            ></v-text-field>

                            <v-text-field
                                label="Adresse Mail"
                                name="email"
                                id="email"
                                v-model="email"
                                placeholder="batman@gotham.com"
                                class="text-xs"
                                outlined
                                :rules="[rules.required, rules.email]"
                            ></v-text-field>

                            <v-text-field
                                label="Mot de passe"
                                name="password"
                                id="password"
                                v-model="password"
                                class="text-xs"
                                outlined
                                :rules="[rules.required]"
                            ></v-text-field>

                            <v-btn class="mt-6 w-full" color="blue" @click.prevent="createUser">
                                S'inscrire
                            </v-btn>
                        </v-form>

                        <v-card-actions class="mt-6 text-sm text-center text-gray-400">
                            Déjà un compte ? 
                            <v-btn text color="blue" @click="toggleForm">Connexion</v-btn>
                        </v-card-actions>
                    </v-card-text>
                </v-card>
            </v-container>
        </div>
    </div>
</template>

<script>
//assets
import logo from '~/assets/logo-batman.png';
import gotham from '~/assets/GothamCity.webp';
//utils
import useUsers from '~/src/utils/user/user';

const { createUser } = useUsers();

export default {
    name: 'auth',
    data() {
        return {
            gotham,
            logo,
            isRegistering: false,
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
        toggleForm() {
            this.isRegistering = !this.isRegistering;
        },
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
