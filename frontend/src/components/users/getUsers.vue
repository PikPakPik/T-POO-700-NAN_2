<template>
    <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8">
        <v-row class="flex items-center justify-center pb-6">
            <v-col class="text-center">
                <h2 class="font-semibold text-gray-700">Comptes d'utilisateurs</h2>
                <span class="text-xs text-gray-500">Consulter les comptes des utilisateurs enregistrés</span>
            </v-col>
        </v-row>
        <v-card class="overflow-y-hidden rounded-lg border flex place-content-between text-center">
            <v-card-text class="overflow-x-auto">
                <v-simple-table>
                    <thead>
                        <tr class="bg-blue-600 text-left text-xs font-semibold uppercase tracking-widest text-white">
                            <th class="px-5 py-3">ID</th>
                            <th class="px-5 py-3">Nom d'utilisateur</th>
                            <th class="px-5 py-3">Role</th>
                            <th class="px-5 pl-6.5 pr-6.5">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="text-gray-500">
                        <tr v-for="user in paginatedUsers" :key="user.id">
                            <td class="border-b border-gray-200 bg-white px-5 py-5 text-sm">
                                <p class="whitespace-no-wrap">{{ user.id }}</p>
                            </td>
                            <td class="border-b border-gray-200 bg-white px-5 py-5 text-sm">
                                <div class="flex items-center">
                                    <v-avatar class="h-10 w-10 flex-shrink-0">
                                        <img src="@/assets/batman-head.png" alt="User Avatar" class="w-10 h-10 rounded-full"/>
                                    </v-avatar>
                                    <div class="ml-3">
                                        <p class="whitespace-no-wrap">{{ user.username }}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="border-b border-gray-200 bg-white px-5 py-5 text-sm">
                                <p class="whitespace-no-wrap">{{ user.role }}</p>
                            </td>
                            <td class="border-b border-gray-200 bg-white px-5 py-5 text-sm">
                                <v-icon @click="confirmDelete(user.id)" class="cursor-pointer hover:text-red-600">mdi-delete</v-icon>
                            </td>
                            <td class="border-b border-gray-200 bg-white px-5 py-5 text-sm">
                                <v-icon @click="editRole(user)" class="cursor-pointer hover:text-blue-600">mdi-pencil</v-icon>
                            </td>
                        </tr>
                    </tbody>
                </v-simple-table>
            </v-card-text>
            <v-card-actions class="flex flex-col items-center border-t bg-white px-5 py-5 sm:flex-row sm:justify-between">
                <span class="text-xs text-gray-600 sm:text-sm"> Affichage {{ (currentPage - 1) * itemsPerPage + 1 }} à {{ Math.min(currentPage * itemsPerPage, users.length) }} sur {{ users.length }} entrées </span>
                <div class="mt-2 inline-flex sm:mt-0">
                    <v-btn @click="prevPage" :disabled="currentPage === 1" class="mr-2 h-12 w-12 rounded-full border text-sm font-semibold text-gray-600 transition duration-150 hover:bg-gray-100">Préc</v-btn>
                    <v-btn @click="nextPage" :disabled="currentPage >= totalPages" class="h-12 w-12 rounded-full border text-sm font-semibold text-gray-600 transition duration-150 hover:bg-gray-100">Suiv</v-btn>
                </div>
            </v-card-actions>
        </v-card>

        <v-dialog v-model="deleteDialog" max-width="400">
            <v-card>
                <v-card-title class="text-h5">Confirmer la suppression</v-card-title>
                <v-card-text>Es-tu sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible.</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="deleteDialog = false">Annuler</v-btn>
                    <v-btn color="red" text @click="deleteSelectedUser(selectedUserId)">Supprimer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="editDialog" max-width="400">
            <v-card>
                <v-card-title class="text-h5">Modifier le rôle</v-card-title>
                <v-card-text>
                    <v-select v-model="selectedUserRole" :items="roles" label="Rôle"></v-select>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="editDialog = false">Annuler</v-btn>
                    <v-btn color="blue" text @click="updateUserRole">Enregistrer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
//utils
import useUsers from '~/src/utils/user/user';

const { getUsers, deleteUser, updateUser } = useUsers();

export default {
    name: 'userList',
    data() {
        return {
            error: null,
            loading: true,
            users: [],
            userRoles: null,
            deleteDialog: false,
            editDialog: false,
            selectedUser: null,
            currentPage: 1,
            itemsPerPage: 10,
            roles: ['Employee', 'Manager', 'Admin'] 
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.users.length / this.itemsPerPage);
        },
        paginatedUsers() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.users.slice(start, end);
        }
    },
    mounted() {
        this.fetchUserData();
    },
    methods: {
        async fetchUserData() {
            try {
                const response = await getUsers();
                this.users = response;
            } catch (error) {
                this.error = 'Failed to load user data';
                this.loading = false;
            }
        },
        confirmDelete(userId) {
            this.selectedUserId = userId;
            this.deleteDialog = true;
        },
        async deleteSelectedUser(userId) {
            try {
                await deleteUser(userId);
                this.deleteDialog = false;
                this.fetchUserData();
            } catch (error) {
                console.error("Failed to delete user:", error);
            }
        },
        editRole(user) {
            this.selectedUser = user
            this.editDialog = true;
        },
        async updateUserRole() {
            try {
                await updateUser(this.selectedUser.id,this.selectedUser.username, this.username.email); //TODO: add , this.selectedUserRole when role is in db 
                this.editDialog = false;
                this.fetchUserData();
            } catch (error) {
                console.error("Failed to update user role:", error);
            }
        },
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
            }
        },
        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        }
    }
};
</script>
