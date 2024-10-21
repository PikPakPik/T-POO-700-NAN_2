<template>
    <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8">
        <v-row class="flex items-center justify-center pb-6">
            <v-col class="text-center">
                <h2 class="font-semibold text-gray-700 underline" aria-label="Team Name">
                    {{ team.name }}
                    <span v-if="teamManagers.length" class="text-sm text-gray-500">- {{ teamManagers[0].username }}</span>
                </h2>
                <span class="text-xs text-gray-500">Consulter votre équipe</span>
            </v-col>
            <v-col class="text-center">
                <ClockManager 
                    class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8" 
                    :id="this.teamId"
                    :isTeam="true"
                    v-if="currentUser.role && (currentUser.role.id == '1' || currentUser.role.id == '2')"/>
            </v-col>
        </v-row>
        
        <v-row justify="start">
        <v-col cols="12">
            <v-card class="transparent-card">
            <v-card-title class="d-flex justify-space-between align-center">
                <v-text-field 
                    v-model="search" 
                    class="search-bar mr-4 teams-details-intro" 
                    label="Recherche"
                    single-line hide-details aria-label="Search user"
                    data-intro="Rechercher ici votre équipe." 
                    data-title="Rechercher d'équipe">
                </v-text-field>
                <v-btn 
                    icon class="mr-2 yellow teams-details-intro" 
                    @click="openAssociateDialog()" 
                    aria-label="Add user" 
                    v-if="currentUser.role && (currentUser.role.id == '1' || currentUser.role.id == '2')"
                    data-intro="Cliquez ici pour assigner un utilisateur à l'équipe." 
                    data-title="Assigner un utilisateur">
                    <v-icon>mdi-plus</v-icon>
                </v-btn>
            </v-card-title>
        <v-data-table :headers="headers" :items="teamMembers" :search="search" item-key="id"
            class="elevation-1 custom-data-table" :items-per-page="itemsPerPage" :page.sync="currentPage" items-per-page-text="Éléments par page"
            :footer-props="customFooterProps" :items-per-page-options="itemsPerPageOptions" aria-label="User accounts table">
                    
            <template v-slot:item.id="{ item }">
                <span aria-label="User ID">{{ item.id }}</span>
            </template>

            <template v-slot:item.employee="{ item }">
                <span aria-label="Employee Name">{{ item.username }}</span>
            </template>

            <template v-slot:item.action="{ item, index }">
                <v-row class="d-flex align-center flex-row no-gutters">
                    <v-btn 
                        icon size="small" 
                        class="mr-2" 
                        @click="confirmDeleteEmployeeFromTeam(item.id)" 
                        aria-label="Delete user"
                        v-if="index === 0"
                        data-intro="Cliquez ici pour supprimer l'utilisateur de l'équipe." 
                        data-title="Désassigner un utilisateur d'une équipe">
                        <v-icon>mdi-trash-can</v-icon>
                    </v-btn>
                    <v-btn 
                        icon size="small" 
                        class="mr-2" 
                        @click="confirmDeleteEmployeeFromTeam(item.id)" 
                        aria-label="Delete user"
                        v-else
                        :class="{ 'teams-details-intro': index === 0 }">
                        <v-icon>mdi-trash-can</v-icon>
                    </v-btn>
                </v-row>
            </template>
        </v-data-table>
            </v-card>
        </v-col>
        </v-row>

        <!-- Associate User Dialog -->
        <v-dialog v-model="associateDialog" max-width="500px" aria-label="Associate User Dialog">
            <v-card>
                <v-card-title>
                    <span class="headline">Associer un utilisateur</span>
                </v-card-title>
                <v-card-text>
                    <v-autocomplete
                        v-model="selectedUser"
                        :items="availableUsers"
                        item-title="username"
                        item-value="id"
                        label="Sélectionner un utilisateur"
                        required
                        aria-label="Select a user"
                    ></v-autocomplete>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeAssociateDialog" aria-label="Cancel">Annuler</v-btn>
                    <v-btn color="blue darken-1" text @click="associateUserToTeam(selectedUser)" aria-label="Associate">Associer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
//components 
import ClockManager from './src/components/clockManager.vue';
//utils
import useTeams from '~/src/utils/team/team';
import useUsers from '~/src/utils/user/user';

const { showTeam, associateEmployee, removeEmployeeFromTeam } = useTeams();

const { getUsers, getUser } = useUsers();

export default {
    name: 'TeamDetails',
    props: {
        teamId: {
            type: Number,
            required: true
        }
    },
    data() {
        return {
            headers: [
                { title: 'ID', text: 'ID', sortable: true, value: 'id' },
                { title: 'Employé(s)', text: 'Employee', sortable: true, value: 'username' },
            ],
            teamManagers: [],
            teamMembers: [],
            team: {},
            itemsPerPage: 10,
            currentPage: 1,
            search: '',
            customFooterProps: {
                'items-per-page-options': [5, 10, 25, 50],
                'show-current-page': true,
                'show-first-last-page': true,
                'show-items-per-page': true,
            },
            itemsPerPageOptions: [5, 10, 25, 50],
            associateDialog: false,
            selectedUser: null,
            currentUser: {},
            availableUsers: []
        };
    },
    methods: {
        async showTeam() {
            try {
                const currentUser = await getUser(1); //to change with auth to handle the user id dynamically (21 = admin) (1 = Manager) (7 = Employee)
                this.currentUser = currentUser;

                if (currentUser.role.id == '1' || currentUser.role.id == '2') {
                    this.headers.push({ title: 'Action', text: 'Actions', sortable: false, value: 'action'});
                }

                const response = await showTeam(this.teamId); 
                this.teamMembers = response.employees;
                this.teamManagers = response.managers;
                this.team = response;
            } catch (error) {
                console.error('Error fetching team members:', error);
            }
        },
        async getUsers() {
            try {
                const response = await getUsers();
                // Filter out users that are already in the team
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
                this.showTeam(); 
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
            try {
                await removeEmployeeFromTeam(this.teamId, employeeId);
                this.showTeam();
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
    },
    mounted() {
        this.showTeam();
        this.getUsers();
    },
    components: {
        ClockManager
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
</style>