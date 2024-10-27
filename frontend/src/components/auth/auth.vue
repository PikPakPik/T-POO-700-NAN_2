<template>
    <div class="bg-white dark:bg-gray-900">
        <div class="flex justify-center h-screen">
            <div class="hidden bg-cover lg:block lg:w-full" :style="{ backgroundImage: `url(${gotham})` }"
                aria-label="Background image of Gotham City">
                <div class="flex items-center h-full px-20 bg-gray-900 bg-opacity-40">
                    <div>
                        <h2 class="text-2xl font-bold text-white sm:text-3xl">GOTHAM TIME MANAGER</h2>
                        <p class="max-w-xl mt-3 text-gray-300">
                            Venez pointer vos heures de travail en toute simplicité pour chasser les méchants et sauver
                            gotham city.
                        </p>
                    </div>
                </div>
            </div>

            <v-container class="flex items-center">
                <v-card class="flex-1 elevation-0">
                    <v-card-title class="text-center">
                        <v-avatar class="mx-auto">
                            <img :src="logo" alt="Logo de Gotham Time Manager" class="w-auto h-7 sm:h-8">
                        </v-avatar>
                        <v-card-subtitle class="mt-3 text-black dark:text-gray-300">
                            <span>Connectez-vous pour accéder à votre compte</span>
                        </v-card-subtitle>
                    </v-card-title>

                    <v-card-text class="mt-8">
                        <v-form @submit.prevent="login" v-model="form">
                            <small id="email-helper" class="text-gray-500">Entrez votre adresse mail.</small>

                             <v-text-field
                                v-model="email"
                                :readonly="loading"
                                :rules="[rules.required, rules.email]"
                                class="mb-2"
                                label="Email"
                                clearable
                            ></v-text-field>


                            <small id="password-helper" class="text-gray-500">Entrez votre mot de passe.</small>
                             <v-text-field
                                v-model="password"
                                :readonly="loading"
                                :rules="[rules.required]"
                                label="Password"
                                placeholder="Enter your password"
                                type="password"
                                name="password"
                                clearable
                                aria-label="Mot de passe" aria-describedby="password-helper"
                                @keyup.enter="login"></v-text-field>
                                
                                <p class="text-red-500 mb-2">{{ error }}</p>
                            <v-btn
                                :disabled="!form"
                                :loading="loading"
                                color="success"
                                size="large"
                                type="submit"
                                variant="elevated"
                                block
        >
                                Se connecter
                            </v-btn>
                        </v-form>

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
import { useAuthStore } from '@/stores/auth';

const { login } = useUsers();


export default {
    name: 'auth',
    data() {
        return {
            form: false,
            gotham,
            loading: false,
            logo,
            email: null,
            password: null,
            error: null,
            rules: {
                required: value => !!value || 'Requis.',
                email: value => {
                    const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
                    return pattern.test(value) || 'Invalid e-mail.';
                },
            },
        };
    },
    methods: {
        async login() {
            this.error = null;
            this.loading = true;
            if (!this.form) return;
            try {
                const response = await login(this.email, this.password);
                if (response && response.data) {
                    const { user, xsrf_token } = response.data;
                    const authStore = useAuthStore();
                    authStore.login(user, xsrf_token);
                    // Redirection avec Nuxt router
                    this.$nuxt.$router.push({ name: 'index' }).catch(err => {
                        console.error('Erreur de redirection:', err);
                    });
                }
            } catch (error) {
                if (error.response && error.response.status === 401) {
                    this.error = 'Accès refusé : Vérifiez vos identifiants.';
                } else {
                    this.error = 'Échec de la connexion.';
                }
            } finally {
                this.loading = false;
            }
        },
    },
};
</script>

