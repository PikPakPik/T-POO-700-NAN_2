<template>
    <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8">
        <v-row class="flex items-center justify-center pb-6">
            <v-col class="text-center">
                <h2 class="font-semibold text-gray-700 underline">Équipes</h2>
                <span class="text-xs text-gray-500">Consulter les équipes enregistrés qui vous sont assignées</span>
            </v-col>
        </v-row>

        <v-row justify="start">
        <v-col cols="12">
            <v-card class="transparent-card">
            <v-card-title class="d-flex justify-space-between align-center">
                <v-text-field 
                    v-model="search" 
                    class="search-bar mr-4 teams-intro" 
                    label="Recherche"
                    single-line hide-details aria-label="Search teams" 
                    data-intro="Rechercher ici votre équipe." 
                    data-title="Rechercher d'équipe">
                </v-text-field>
                <v-btn 
                    icon class="mr-2 yellow teams-intro" 
                    @click="openCreateDialog()" 
                    data-intro="Cliquez ici pour ajouter une nouvelle équipe." 
                    data-title="Ajouter une équipe" aria-label="Create new team"
                    v-if="user.role && (user.role.id == '1' || user.role.id == '2')">
                    <v-icon>mdi-plus</v-icon>
                </v-btn>
            </v-card-title>
            <v-data-table 
                :headers="headers" 
                :items="teams" 
                :search="search" 
                item-key="id"
                class="elevation-1 custom-data-table" 
                :items-per-page="itemsPerPage" 
                :page.sync="currentPage" 
                items-per-page-text="Éléments par page"
                :footer-props="customFooterProps" 
                :items-per-page-options="options.itemsPerPageOptions" 
                aria-label="User accounts table">
                
                <template v-slot:item.id="{ item }">
                    <span aria-label="Team ID">{{ item.id }}</span>
                </template>

                <template v-slot:item.manager="{ item }">
                    <span aria-label="Manager Name">{{ managers[item.id] || 'Chargement...' }}</span>
                </template>

                <template v-slot:item.action="{ item, index }">
                <v-row class="d-flex align-center flex-row no-gutters">
                    <v-btn 
                        icon size="small" 
                        class="mr-2" 
                        @click="editTeam(item)" 
                        aria-label="Edit team" 
                        v-if="user.role && (user.role.id == '1' || user.role.id == '2')" 
                        :class="{ 'teams-intro': index === 0, 'mr-2': index >= 0 }"
                        data-intro="Cliquez ici pour éditer l'équipe sélectionnée." 
                        data-title="Éditer une équipe">
                        <v-icon>mdi-pencil</v-icon>
                    </v-btn>
                    <v-btn 
                        icon size="small" 
                        class="mr-2" 
                        @click="confirmDeleteFromTeam(item.id)" 
                        aria-label="Delete team" 
                        v-if="user.role && (user.role.id == '1' || user.role.id == '2')"
                        :class="{ 'teams-intro': index === 0, 'mr-2': index >= 0 }"
                        data-intro="Cliquez ici pour supprimer l'équipe sélectionnée." 
                        data-title="Supprimer une équipe">
                        <v-icon>mdi-trash-can</v-icon>
                    </v-btn>
                    <v-btn 
                        icon size="small" 
                        class="mr-2" 
                        @click="viewTeamDetails(item.id)" 
                        aria-label="View team details"
                        :class="{ 'teams-intro': index === 0, 'mr-2': index >= 0 }"
                        data-intro="Cliquez ici pour regarder le détail de l'équipe sélectionnée." 
                        data-title="Montrer l'équipe">
                        <v-icon>mdi-eye</v-icon>
                    </v-btn>
                </v-row>
                </template>
            </v-data-table>
            </v-card>
        </v-col>
        </v-row>

        <!-- Confirmation dialog -->
        <v-dialog v-model="deleteDialog" max-width="400" aria-label="Delete confirmation dialog">
            <v-card>
                <v-card-title class="text-h5">Confirmer la suppression</v-card-title>
                <v-card-text>Es-tu sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible.</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="deleteDialog = false" aria-label="Cancel delete">Annuler</v-btn>
                    <v-btn color="red" text @click="deleteSelectedTeam(selectedTeamId)" aria-label="Confirm delete">Supprimer</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
        
        <!-- Edit dialog -->
        <v-dialog v-model="editDialog" max-width="400" aria-label="Edit team name dialog">
            <v-card>
            <v-card-title class="text-h5">Modifier le nom de l'équipe</v-card-title>
            <v-card-text>
                <v-text-field v-model="selectedTeamName" label="Nom de l'équipe" aria-label="Team name"></v-text-field>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue-grey" text @click="editDialog = false" aria-label="Cancel edit">Annuler</v-btn>
                <v-btn color="blue" text @click="updateTeam" aria-label="Save team name">Enregistrer</v-btn>
            </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Create dialog -->
        <v-dialog v-model="createDialog" max-width="400" aria-label="Create team dialog">
            <v-card>
            <v-card-title class="text-h5">Créer une équipe</v-card-title>
            <v-card-text>
            <v-form ref="createTeamForm">
            <v-text-field v-model="newTeamName" label="Nom de l'équipe" aria-label="Team name"></v-text-field>
            </v-form>
            </v-card-text>
            <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue-grey" text @click="createDialog = false" aria-label="Cancel create">Annuler</v-btn>
            <v-btn color="blue" text @click="createTeam" aria-label="Create team">Créer</v-btn>
            </v-card-actions>
            </v-card>
        </v-dialog>  
    </v-container>
</template>

<script>
//utils
import useTeams from '~/src/utils/team/team';
import useUsers from '~/src/utils/user/user';

const { getTeams, createTeams, deleteTeam, updateTeam, showTeam, associateManager } = useTeams();
const { getUser } = useUsers();

export default {
    name: 'userList',
    data() {
        return {
            headers: [
                { title: 'ID', text: 'ID', sortable: true, value: 'id' },
                { title: 'Nom d\'équipe', text: 'Nom d\'équipe', sortable: true, value: 'name' },
                { title: 'Manager', text: 'Manager', sortable: true, value: 'manager' },
                { title: 'Actions', text: 'Actions', sortable: false, value: 'action'}
            ],
            search: '',
            managers: {},
            error: null,
            loading: true,
            teams: [],
            deleteDialog: false,
            editDialog: false,
            createDialog: false,
            newTeamName: '',
            viewDialog: false,
            currentPage: 1,
            selectedTeam: null,
            user: {},
            options: {
                itemsPerPageOptions: [5, 10, 25, 50]
            },
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.teams.length / this.itemsPerPage);
        },
    },
    mounted() {
        this.fetchTeamData();
    },
    methods: {
        async showManager(teamID) {
            try {
                const response = await showTeam(teamID); 
                return response.managers[0].username; 
            } catch (error) {
                console.error("Failed to fetch manager:", error);
                return 'N/A';  // Si erreur, afficher N/A
            }
        },
        async fetchTeamData() {
            try {
                const response = await getUser(1); //to change with auth to handle the user id dynamically (21 = admin) (1 = Manager) (7 = Employee)
                this.user = response;

                if (this.user.role.id == '1') {
                    const response = await getTeams();
                    this.teams = response;

                } else if (this.user.role.id == '2') {
                    this.teams = [...this.user.teams, ...this.user.managed_teams];

                } else {
                    this.teams = this.user.teams;
                }

                for (let team of this.teams) {
                        const manager = await this.showManager(team.id);
                        this.managers[team.id] = manager;
                    }

            } catch (error) {
                this.error = 'Failed to load user data';
                this.loading = false;
            }
        },
        openCreateDialog() {
            this.createDialog = true;
        },
        confirmDeleteFromTeam(teamID) {
            this.selectedTeamId = teamID;
            this.deleteDialog = true;
        },
        async deleteSelectedTeam(teamId) {
            try {
                await deleteTeam(teamId);
                this.deleteDialog = false;
                this.fetchTeamData();
            } catch (error) {
                console.error("Failed to delete user:", error);
            }
        },
        async createTeam() {
            try {
                const response = await createTeams(this.newTeamName);
                await associateManager(response.id, this.user.id);
                this.createDialog = false;
                this.fetchTeamData();
            } catch (error) {
                console.error("Failed to create team:", error);
            }
        },
        editTeam(team) {
            this.selectedTeamName = team.name;
            this.selectedTeam = team;
            this.editDialog = true;
        },
        async updateTeam() {
            try {
                await updateTeam(this.selectedTeam.id, this.selectedTeamName);
                this.editDialog = false;
                this.fetchTeamData();
            } catch (error) {
                console.error("Failed to update teams:", error);
            }
        },
        viewTeamDetails(teamID) {
            this.$router.push('/teams/' + teamID);
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
