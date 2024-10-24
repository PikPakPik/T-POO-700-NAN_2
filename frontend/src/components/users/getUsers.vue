<template>
    <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8">
        <v-row class="flex items-center justify-center pb-6">
            <v-col class="text-center">
                <h2 class="font-semibold text-gray-700 underline">Comptes d'utilisateurs</h2>
                <span class="text-xs text-gray-500">Consulter les comptes des utilisateurs enregistrés</span>
            </v-col>
        </v-row>

        <v-row justify="start">
        <v-col cols="12">
            <v-card class="transparent-card">
            <v-card-title class="d-flex justify-space-between align-center">
                <v-text-field 
                    v-model="search" 
                    class="search-bar mr-4" 
                    label="Search"
                    single-line hide-details aria-label="Search users">
                </v-text-field>
                <v-btn 
                    icon class="mr-2 yellow users-intro" 
                    @click="openCreateDialog()" 
                    data-intro="Cliquez ici pour ajouter un nouveau utilisateur." 
                    data-title="Ajouter un utilisateur" aria-label="Add user"
                    v-if="currentUser.role && (currentUser.role.id == '1')">
                    <v-icon>mdi-plus</v-icon>
                </v-btn>
            </v-card-title>
            <v-data-table :headers="headers" :items="users" :search="search" item-key="id"
                class="elevation-1 custom-data-table" :items-per-page="itemsPerPage" :page.sync="currentPage" items-per-page-text="Éléments par page"
                :footer-props="customFooterProps" :items-per-page-options="options.itemsPerPageOptions" aria-label="User accounts table">
                
                <template v-slot:item.id="{ item }">
                    <span aria-label="User ID">{{ item.id }}</span>
                </template>
                <template v-slot:item.action="{ item }">
                  <div v-if="isMobile">
                    <v-btn icon class="icon-btn-mobile" @click="showBottomSheet(item)">
                      <v-icon>mdi-dots-vertical</v-icon>
                    </v-btn>
                  </div>
                  <div v-else>
                    <v-row class="d-flex align-center flex-row no-gutters">
                      <v-btn 
                        icon 
                        size="small" 
                        class="mr-2" 
                        @click="editRole(item)" 
                        aria-label="Edit role"
                        :class="{ 'users-intro': index === 0, 'mr-2': index >= 0 }"
                        data-intro="Cliquez ici pour éditer l'utilisateur sélectionné."
                        data-title="Éditer un utilisateur">
                        <v-icon>mdi-pencil</v-icon>
                      </v-btn>
                      <v-btn icon size="small" class="mr-2" @click="confirmDelete(item.id)" aria-label="Delete user">
                        <v-icon>mdi-trash-can</v-icon>
                      </v-btn>
                    </v-row>
                  </div>
                </template>
                </v-data-table>
                </v-card>
            </v-col>
        </v-row>

        <!-- Confirmation dialog -->
        <v-dialog v-model="deleteDialog" max-width="400" aria-label="Delete confirmation dialog">
            <v-card>
                <v-card-title class="text-h5">Confirmer la suppression</v-card-title>
                <v-card-text>Es-tu sûr de vouloir supprimer cet utilisateur ? Cette action est
                    irréversible.</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="deleteDialog = false"
                        aria-label="Cancel delete">Annuler</v-btn>
                    <v-btn color="red" text @click="deleteSelectedUser(selectedUserId)"
                        aria-label="Confirm delete">Supprimer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Edit dialog -->
        <v-dialog v-model="editDialog" max-width="400" aria-label="Edit role dialog">
            <v-card>
                <v-card-title class="text-h5">Modifier le rôle</v-card-title>
                <v-card-text>
                    <v-select v-model="selectedUserRole" :items="roles" label="Rôle"
                        aria-label="Select user role"></v-select>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="editDialog = false" aria-label="Cancel edit">Annuler</v-btn>
                    <v-btn color="blue" text @click="updateUserRole" aria-label="Save role">Enregistrer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Create dialog -->
        <v-dialog v-model="createDialog" max-width="500" aria-label="Create user dialog">
            <v-card>
            <v-card-title class="text-h5">Ajouter un utilisateur</v-card-title>
            <v-card-text>
                <v-form>
                <v-text-field 
                    label="Nom d'utilisateur" 
                    v-model="newUser.username" 
                    :rules="[rules.required]" 
                    outlined 
                    aria-label="Nom d'utilisateur">
                </v-text-field>
                <v-text-field 
                    label="Adresse Mail" 
                    v-model="newUser.email" 
                    :rules="[rules.required, rules.email]" 
                    outlined 
                    aria-label="Adresse Mail">
                </v-text-field>
                <v-text-field 
                    label="Mot de passe" 
                    v-model="newUser.password" 
                    :rules="[rules.required]" 
                    outlined 
                    type="password" 
                    aria-label="Mot de passe">
                </v-text-field>
                <v-select 
                    v-model="newUser.role" 
                    :items="roles" 
                    label="Rôle" 
                    outlined 
                    aria-label="Rôle">
                </v-select>
                </v-form>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue-grey" text @click="createDialog = false" aria-label="Annuler">Annuler</v-btn>
                <v-btn color="blue" text @click="createUser" aria-label="Ajouter">Ajouter</v-btn>
            </v-card-actions>
            </v-card>
        </v-dialog>
        
    </v-container>
</template>

<script>
//utils
import useUsers from '~/src/utils/user/user';
import { useAuthStore } from '@/stores/auth';

const { getUser, getUsers, deleteUser, updateUserRole, createUser } = useUsers();

export default {
    name: 'userList',
    data() {
        return {
            headers: [
                { title: 'ID', text: 'ID', sortable: true, value: 'id' },
                { title: 'Nom d\'utilisateur', text: 'Nom d\'utilisateur', sortable: true, value: 'username' },
                { title: 'Rôle', text: 'Role', sortable: true, value: 'role.name' },
            ],
            search: '',
            error: null,
            loading: true,
            users: [],
            currentUser: {},
            deleteDialog: false,
            editDialog: false,
            createDialog: false,
            selectedUser: null,
            selectedUserRole: null,
            newUser: {
                username: '',
                email:'',
                password:'',
                role: 'Employee'
            },
            rules: {
                required: value => !!value || 'Requis.',
                email: value => {
                    const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    return pattern.test(value) || 'Email non valide.';
                },
            },
            currentPage: 1,
            options: {
                itemsPerPageOptions: [5, 10, 25, 50]
            },
            roles: ['Employee', 'Manager', 'Admin'],
            bottomSheetVisible: false,
            isMobile: false
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.users.length / this.itemsPerPage);
        },
        isAdmin() {
            const authStore = useAuthStore();
            return authStore.getUserRoles.includes('Admin');
        },
        headersWithActions() {
            if (this.isAdmin) {
                return [
                    ...this.headers,
                    { title: 'Actions', text: 'Actions', sortable: false, value: 'action' }
                ];
            }
            return this.headers;
        }
    },
    mounted() {
        this.detectMobile();
        window.addEventListener('resize', this.detectMobile);
        this.fetchUserData();
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.detectMobile);
    },
    methods: {
        async fetchUserData() {
            try {
                //getUserID from localStorage
                this.currentUser = await getUser(localStorage.getItem('userID'));

                if (this.currentUser.role.id !== 1) {
                    this.headers = this.headers.filter(header => header.value !== 'action');
                }

                //get all users
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
                const userIndex = this.users.findIndex(user => user.id === userId);
                if (userIndex !== -1) {
                    this.users.splice(userIndex, 1);
                }
                this.deleteDialog = false;
                this.bottomSheetVisible = false;
            } catch (error) {
                console.error("Failed to delete user:", error);
            }
        },
        editRole(user) {
            this.selectedUser = user;
            this.editDialog = true;
        },
        formatUserRole(selectedUserRole) {
            switch (selectedUserRole) {
                case 'Employee':
                    return 3;
                case 'Manager':
                    return 2;
                case 'Admin':
                    return 1;
                default:
                    return 3;
            }
        },
        async updateUserRole() {
            try {
                const roleID = this.formatUserRole(this.selectedUserRole);
                await updateUserRole(this.selectedUser.id, roleID);
                const userIndex = this.users.findIndex(user => user.id === this.selectedUser.id);
                if (userIndex !== -1) {
                    this.users[userIndex].role.name = this.selectedUserRole;
                }
                this.editDialog = false;
                this.bottomSheetVisible = false;
            } catch (error) {
                console.error("Failed to update user role:", error);
            }
        },
        async createUser() {
            try {
                const roleID = this.formatUserRole(this.newUser.role);
                const newUser = await createUser(this.newUser.username, this.newUser.email, this.newUser.password, roleID );
                this.users.push(newUser);
                this.createDialog = false;
                this.newUser = { email: '', username: '', password: '', role: 'Employee' };
            } catch (error) {
                console.error("Failed to create user:", error);
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
        },
        detectMobile() {
            this.isMobile = window.innerWidth <= 950;
        },
        showBottomSheet(item) {
          this.item = item;
          this.bottomSheetVisible = true;
        },
        openCreateDialog() {
            this.createDialog = true;
        }
    }
};
</script>

<style scoped>
:deep(.v-data-table) thead {
    background-color: #FFC107 !important;
    font-weight: bold;
    font-size: 1.2em;
}

:deep(.v-data-table) .v-data-table__tr>* {
    border-bottom: none !important;
    /* Supprime les séparations entre les lignes */
}

:deep(.v-data-table) .v-data-table__tr:nth-child(odd) {
    background-color: #e1dfdf !important;
    border-bottom: none !important;
    /* Gris très clair pour les lignes impaires */
}

:deep(.v-data-table) .v-data-table__tr:nth-child(even) {
    background-color: #ffffff !important;
    border-bottom: none !important;
    /* Blanc pour les lignes paires */
}

.v-card {
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.icon-btn-mobile {
    background-color: transparent !important;
    box-shadow: none !important;
    padding: 0 !important;
    width: auto !important;
    height: auto !important;
    min-width: 0 !important;
    border: none !important;
}

.icon-btn-mobile {
    font-size: 20px;
    color: #000;
}
</style>