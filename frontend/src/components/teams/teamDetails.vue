<template>
    <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8">
        <v-row class="flex items-center justify-center pb-6">
            <v-col class="text-center">
                <div class="d-flex align-center justify-center">
                <h2 class="font-semibold text-gray-700 underline" aria-label="Team Name">
                    {{ team.name }}
                </h2>
                <v-btn color="primary" class="ml-4" @click="editDialog = true" v-if="isManager">
                    <v-icon>mdi-pencil</v-icon>
                </v-btn>
                </div>
                <span class="text-xs text-gray-500">Consulter votre équipe</span>
            </v-col>
        </v-row>
        <v-row class="flex items-center justify-center pb-6" v-if="isManager">
            <v-col class="text-center">
                <v-btn class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8" @click="openWorkingTimeDialog"
                    v-role-not="'Employee'">
                    Pointez pour vos employés
                </v-btn>
            </v-col>
        </v-row>

        <!-- Working Time Dialog -->
        <v-dialog v-model="workingTimeDialog" max-width="800px" aria-label="Working Time Dialog">
            <Working-time :teamID="teamId" @close="workingTimeDialog = false" />
        </v-dialog>

        <v-row justify="start">
            <v-col cols="12">
                <v-card class="transparent-card">
                    <v-card-title class="d-flex justify-space-between align-center">
                        <v-text-field v-model="search" class="search-bar mr-4 teams-details-intro" label="Recherche"
                            single-line hide-details aria-label="Search user" data-intro="Rechercher ici votre équipe."
                            data-title="Rechercher d'équipe">
                        </v-text-field>
                        <v-btn icon class="mr-2 yellow teams-details-intro" @click="openAssociateDialog()"
                            aria-label="Add user" v-role-not="'Employee'"
                            data-intro="Cliquez ici pour assigner un utilisateur à l'équipe."
                            data-title="Assigner un utilisateur">
                            <v-icon>mdi-plus</v-icon>
                        </v-btn>
                    </v-card-title>
                    <!-- Tableau pour les managers -->
                    <v-data-table :headers="headers_managers" :items="teamManagers" :search="search" item-key="id"
                        class="elevation-1 custom-data-table" :items-per-page="itemsPerPage" :page.sync="currentPage"
                        items-per-page-text="Éléments par page" :footer-props="customFooterProps"
                        :items-per-page-options="itemsPerPageOptions" aria-label="Manager accounts table"
                        >
                        <template v-slot:item.id="{ item }">
                            <span aria-label="User ID">{{ item.id }}</span>
                        </template>

                        <template v-slot:item.employee="{ item }">
                            <span aria-label="Manager Name">{{ item.username }}</span>
                        </template>

                        <template v-slot:item.action="{ item, index }">
                            <div v-if="isMobile">
                                <v-btn icon class="icon-btn-mobile" @click="showBottomSheetManager(item)">
                                    <v-icon>mdi-dots-vertical</v-icon>
                                </v-btn>
                            </div>
                            <div v-else>
                                <v-row class="d-flex align-center flex-row no-gutters">
                                    <v-btn icon size="small" class="mr-2"
                                        @click="confirmDeleteManagerFromTeam(item.id)" aria-label="Delete user"
                                        :class="{ 'teams-details-intro': index === 0, 'mr-2': index >= 0 }"
                                        data-intro="Cliquez ici pour supprimer l'utilisateur de l'équipe."
                                        data-title="Désassigner un utilisateur d'une équipe">
                                        <v-icon>mdi-trash-can</v-icon>
                                    </v-btn>
                                    <v-btn icon size="small" class="mr-2"
                                        @click="demoteToEmployee(item.id)" aria-label="Demote to employee"
                                        :class="{ 'teams-details-intro': index === 0, 'mr-2': index >= 0 }"
                                        data-intro="Cliquez ici pour rétrograder l'utilisateur en employé."
                                        data-title="Rétrograder un utilisateur en employé">
                                        <v-icon>mdi-shield-account</v-icon>
                                    </v-btn>
                                </v-row>
                            </div>
                        </template>
                    </v-data-table>
                    <!-- Tableau pour les employés -->
                    <v-data-table :headers="headers_employees" :items="teamMembers" :search="search" item-key="id"
                        class="elevation-1 custom-data-table" :items-per-page="itemsPerPage" :page.sync="currentPage"
                        items-per-page-text="Éléments par page" :footer-props="customFooterProps"
                        :items-per-page-options="itemsPerPageOptions" aria-label="User accounts table"
                       >
                        <template v-slot:item.id="{ item }">
                            <span aria-label="User ID">{{ item.id }}</span>
                        </template>

                        <template v-slot:item.employee="{ item }">
                            <span aria-label="Employee Name">{{ item.username }}</span>
                        </template>

                        <template v-slot:item.action="{ item, index }">
                            <div v-if="isMobile">
                                <v-btn icon class="icon-btn-mobile" @click="showBottomSheetEmployee(item)">
                                    <v-icon>mdi-dots-vertical</v-icon>
                                </v-btn>
                            </div>
                            <div v-else>
                                <v-row class="d-flex align-center flex-row no-gutters">
                                    <v-btn icon size="small" class="mr-2"
                                        @click="confirmDeleteEmployeeFromTeam(item.id)" aria-label="Delete user"
                                        :class="{ 'teams-details-intro': index === 0, 'mr-2': index >= 0 }"
                                        data-intro="Cliquez ici pour supprimer l'utilisateur de l'équipe."
                                        data-title="Désassigner un utilisateur d'une équipe">
                                        <v-icon>mdi-trash-can</v-icon>
                                    </v-btn>
                                    <v-btn icon size="small" class="mr-2"
                                        @click="promoteToManager(item.id)" aria-label="Promote to manager"
                                        :class="{ 'teams-details-intro': index === 0, 'mr-2': index >= 0 }"
                                        data-intro="Cliquez ici pour promouvoir l'utilisateur en manager."
                                        data-title="Promouvoir un utilisateur en manager">
                                        <v-icon>mdi-crown</v-icon>
                                    </v-btn>
                                </v-row>
                            </div>
                        </template>
                    </v-data-table>
                </v-card>
            </v-col>
        </v-row>

        <v-bottom-sheet v-model="bottomSheetEmployeeVisible">
            <v-list>
                <v-list-item @click="confirmDeleteEmployeeFromTeam(item.id)">
                    <v-list-item-title>Supprimer l'employé de l'équipe</v-list-item-title>
                </v-list-item>
                <v-list-item @click="promoteToManager(item.id)">
                    <v-list-item-title>Promouvoir l'employé en manager</v-list-item-title>
                </v-list-item>
            </v-list>
        </v-bottom-sheet>

        <v-bottom-sheet v-model="bottomSheetManagerVisible">
            <v-list>
                <v-list-item @click="confirmDeleteEmployeeFromTeam(item.id)">
                    <v-list-item-title>Supprimer le manager de l'équipe</v-list-item-title>
                </v-list-item>
                <v-list-item @click="demoteToEmployee(item.id)">
                    <v-list-item-title>Rétrograder le manager en employé</v-list-item-title>
                </v-list-item>
            </v-list>
        </v-bottom-sheet>

        <!-- Associate User Dialog -->
        <v-dialog v-model="associateDialog" max-width="500px" aria-label="Associate User Dialog">
            <v-card>
                <v-card-title>
                    <span class="headline">Associer un utilisateur</span>
                </v-card-title>
                <v-card-text>
                    <v-autocomplete v-model="selectedUser" :items="availableUsers" item-title="username" item-value="id"
                        label="Sélectionner un utilisateur" required aria-label="Select a user"></v-autocomplete>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeAssociateDialog" aria-label="Cancel">Annuler</v-btn>
                    <v-btn color="blue darken-1" text @click="associateUserToTeam(selectedUser)"
                        aria-label="Associate">Associer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Confirmation dialog -->
        <v-dialog v-model="deleteDialog" max-width="400" aria-label="Delete confirmation dialog">
            <v-card>
                <v-card-title class="text-h5">Confirmer la suppression</v-card-title>
                <v-card-text>Es-tu sûr de vouloir supprimer cet utilisateur ? Cette action est
                    irréversible.</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="deleteDialog = false" aria-label="Cancel delete">Annuler
                    </v-btn>
                    <v-btn color="red" text @click="deleteSelectedEmployeeFromTeam()" aria-label="Confirm delete">
                        Supprimer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

         <!-- Edit dialog -->
        <v-dialog v-model="editDialog" max-width="400" aria-label="Edit team name dialog">
            <v-card>
                <v-card-title class="text-h5">Modifier le nom de l'équipe</v-card-title>
                <v-card-text>
                    <v-text-field v-model="selectedTeamName" label="Nom de l'équipe" aria-label="Team name">
                    </v-text-field>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="editDialog = false" aria-label="Cancel edit">Annuler</v-btn>
                    <v-btn color="blue" text @click="updateTeamConfirmation" aria-label="Save team name">Enregistrer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
// Importing components and utilities
import WorkingTime from './src/components/workingTime.vue';
import { useAuthStore } from '@/stores/auth';
import { useTeams } from '~/src/utils/team/team';
import { useUsers } from '~/src/utils/user/user';

const { showTeam, associateEmployee, removeEmployeeFromTeam, removeManagerFromTeam, associateManager, updateTeam } = useTeams();
const { getUsers, getUser } = useUsers();

export default {
    name: 'TeamDetails',
    components: { WorkingTime },
    props: {
        teamId: { type: Number, required: true }
    },
    data() {
        return {
            // Initial data setup
            team: {},
            teamMembers: [],
            teamManagers: [],
            availableUsers: [],
            search: '',
            isMobile: false,
            workingTimeDialog: false,
            associateDialog: false,
            selectedUser: null,
            // Table configurations
            headers_employees: [],
            headers_managers: [],
            itemsPerPageOptions: [5, 10, 25, 50],
            customFooterProps: {
                'items-per-page-options': this.itemsPerPageOptions,
                'show-current-page': true,
                'show-first-last-page': true,
                'show-items-per-page': true,
            },
            currentPage: 1,
            deleteDialog: false,
            itemsPerPage: 10,
            bottomSheetEmployeeVisible: false,
            bottomSheetManagerVisible: false,
            editDialog: false,
            selectedTeamName: '',
            isManager: false,
        };
    },
    computed: {
        filteredUsers() {
            return this.availableUsers.filter(user => !this.teamMembers.some(member => member.id === user.id));
        },
    },
    methods: {
        initTableHeaders(type) {
            return [
                { title: 'ID', text: 'ID', sortable: true, value: 'id', width: '24%' },
                { title: `${type}(s)`, text: type, sortable: true, value: 'username', width: '33%' },
                ...(this.isManager ? [{ title: 'Action', text: 'Action', sortable: false, value: 'action', width: '43%' }] : [])
            ];
        },
        async updateTeamConfirmation() {
            try {
                await updateTeam(this.team.id, this.selectedTeamName);
                this.editDialog = false;
                this.showTeamInfo();
            } catch (error) {
                console.error("Failed to update teams:", error);
            }
        },
        async showTeamInfo() {
            try {
                const response = await showTeam(this.teamId);
                this.team = response;
                this.teamMembers = response.employees;
                this.teamManagers = response.managers;
                this.checkIfManager();
                this.headers_employees = this.initTableHeaders('Employee');
                this.headers_managers = this.initTableHeaders('Manager');
            } catch (error) {
                console.error('Error fetching team members:', error);
            }
        },
        async getUsers() {
            try {
                const response = await getUsers();
                this.availableUsers = response.filter(user => !this.teamMembers.find(member => member.id === user.id));
            } catch (error) {
                console.error('Error fetching users:', error);
                this.availableUsers = [];
            }
        },
        async associateUserToTeam(userId) {
            if (!userId) {
                console.error('No user selected');
                return;
            }
            try {
                await associateEmployee(this.teamId, userId);
                this.showTeamInfo();
                this.closeAssociateDialog();
            } catch (error) {
                console.error('Error associating user to team:', error);
            }
        },
        async confirmDeleteEmployeeFromTeam(employeeId) {
            if (!employeeId) {
                console.error('No employee selected');
                return;
            }
            this.deleteDialog = true;
            this.selectedEmployeeId = employeeId;
        },
        async deleteSelectedEmployeeFromTeam() {
            try {
                await removeEmployeeFromTeam(this.teamId, this.selectedEmployeeId);
                this.teamMembers = this.teamMembers.filter(member => member.id !== this.selectedEmployeeId);
                this.deleteDialog = false;
            } catch (error) {
                console.error('Error deleting employee from team:', error);
            }
        },
        openAssociateDialog() {
            this.associateDialog = true;
            if (this.availableUsers.length === 0) {
                this.getUsers();
            }
        },
        closeAssociateDialog() {
            this.associateDialog = false;
            this.selectedUser = null;
        },
        detectMobile() {
            this.isMobile = window.innerWidth <= 960;
        },
        showBottomSheetEmployee(item) {
            this.item = item;
            this.bottomSheetEmployeeVisible = true;
        },
        showBottomSheetManager(item) {
            this.item = item;
            this.bottomSheetManagerVisible = true;
        },
        openWorkingTimeDialog() {
            this.workingTimeDialog = true;
        },
        async promoteToManager(employeeId) {
            await removeEmployeeFromTeam(this.teamId, employeeId);
            await associateManager(this.teamId, employeeId);
            this.showTeamInfo();
        },
        async demoteToEmployee(userId) {
            await removeManagerFromTeam(this.teamId, userId);
            await associateEmployee(this.teamId, userId);
            this.showTeamInfo();
        },
        checkIfManager() {
            const authStore = useAuthStore();
            // Vérifiez que authStore et authStore.user sont définis avant d'accéder à leurs propriétés
            if (authStore && authStore.user) {
                this.isManager = this.teamManagers.some(manager => manager.id === authStore.user.id) || authStore.isAdmin;
            } else {
                this.isManager = false;
            }
            this.isManager ? this.isManager : authStore.isAdmin
            console.log(this.isManager);
            return this.isManager;
        },
    },
    mounted() {
        this.detectMobile();
        window.addEventListener('resize', this.detectMobile);
        this.showTeamInfo();
        this.getUsers();
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.detectMobile);
    }
};
</script>

<style scoped>
h1 {
    font-size: 24px;
    margin-bottom: 20px;
}

ul {
    list-style-type: none;
    padding: 0;
}

li {
    margin: 5px 0;
}
</style>

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

.icon-btn-mobile .v-icon {
    font-size: 20px;
    color: #000;
}

.highlight-row {
    background-color: #FFEB3B; /* Jaune */
}
</style>









