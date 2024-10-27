<template>
    <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8">
        <v-row class="flex items-center justify-center pb-6">
            <v-col class="text-center">
                <h2 class="font-semibold text-gray-700 underline">Équipes</h2>
                <span class="text-xs text-gray-500">Consulter les équipes enregistrés qui vous sont assignées</span>
            </v-col>
        </v-row>

        <v-row justify="start">
            <v-row v-if="employee_teams.length > 0" class="flex items-center justify-center pb-6 w-full">
                <v-col class="text-center">
                    <h3 class="font-semibold text-gray-700 underline">Équipes auxquelles vous êtes employé(e)</h3>
                </v-col>
            </v-row>
            <v-col cols="6" v-for="team in employee_teams" :key="'emp-' + team.id">
                <v-card class="mb-4 cursor-pointer" @click="viewTeamDetails(team.id)">
                    <v-card-title>{{ team.name }}</v-card-title>
                    <v-card-subtitle>Employé</v-card-subtitle>
                    <v-card-text>
                        Manager(s): <span v-for="(managerDetails, managerId) in managers[team.id]" :key="managerId">{{ managerDetails }}, </span>
                    </v-card-text>
                </v-card>
            </v-col>

            <v-row v-if="managed_teams.length > 0" class="flex items-center justify-center pb-6 w-full">
                <v-col class="text-center">
                    <h3 class="font-semibold text-gray-700 underline">Équipes auxquelles vous gérez</h3>
                </v-col>
            </v-row>
            <v-col cols="6" v-for="team in managed_teams" :key="'man-' + team.id">
                <v-card class="mb-4 cursor-pointer" @click="viewTeamDetails(team.id)">
                    <v-card-title>{{ team.name }}</v-card-title>
                    <v-card-subtitle>Manager</v-card-subtitle>
                    <v-card-text>
                        Manager(s): <span v-for="(managerDetails, managerId) in managers[team.id]" :key="managerId">{{ managerDetails }}, </span>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-row v-if="other_teams.length > 0 && authStore.isAdmin" class="flex items-center justify-center pb-6 w-full">
                <v-col class="text-center">
                    <h3 class="font-semibold text-gray-700 underline">Autres équipes</h3>
                </v-col>
            </v-row>
            <v-col cols="12" v-for="team in other_teams" :key="'oth-' + team.id">
                <v-card class="mb-4 cursor-pointer" @click="viewTeamDetails(team.id)">
                    <v-card-title>{{ team.name }}</v-card-title>
                    <v-card-subtitle>Autres</v-card-subtitle>
                     <v-card-text>
                        Manager(s): <span v-for="(managerDetails, managerId) in managers[team.id]" :key="managerId">{{ managerDetails }}, </span>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>

        <!-- Create dialog -->
        <v-dialog v-model="createDialog" max-width="400" aria-label="Create team dialog">
            <v-card>
                <v-card-title class="text-h5">Créer une équipe</v-card-title>
                <v-card-text>
                    <v-form ref="createTeamForm">
                        <v-text-field v-model="newTeamName" label="Nom de l'équipe" aria-label="Team name">
                        </v-text-field>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-grey" text @click="createDialog = false" aria-label="Cancel create">Annuler
                    </v-btn>
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
    import {
        meTeams
} from '~/src/utils/api/me';
    import { useAuthStore } from '~/stores/auth';

    const {
        createTeams,
        deleteTeam,
        updateTeam,
        getTeams,
        showTeam,
        associateManager
    } = useTeams();
    const {
        getUser
    } = useUsers();
    
    export default {
        name: 'userList',
        setup() {
            const authStore = useAuthStore();
            return { authStore };
        },
        data() {
            return {
                headers: [{
                        title: 'ID',
                        text: 'ID',
                        sortable: true,
                        value: 'id',
                        width: '10%'
                    },
                    {
                        title: 'Nom d\'équipe',
                        text: 'Nom d\'équipe',
                        sortable: true,
                        value: 'name',
                        width: '40%'
                    },
                    {
                        title: 'Manager',
                        text: 'Manager',
                        sortable: true,
                        value: 'manager',
                        width: '30%'
                    },
                    {
                        title: 'Actions',
                        text: 'Actions',
                        sortable: false,
                        value: 'action',
                        width: '20%'
                    }
                ],
                search: '',
                managers: {},
                teams: [],
                employee_teams: [],
                managed_teams: [],
                other_teams: [],
                deleteDialog: false,
                editDialog: false,
                createDialog: false,
                newTeamName: '',
                currentPage: 1,
                selectedTeam: null,
                user: {},
                options: {
                    itemsPerPageOptions: [5, 10, 25, 50]
                },
                isMobile: false,
                selectedTeamId: null,
                selectedTeamName: '',
            };
        },
        computed: {
            totalPages() {
                return Math.ceil(this.teams.length / this.itemsPerPage);
            },
            otherTeams() {
                return this.teams.filter(team =>
                    !this.employee_teams.some(eTeam => eTeam.id === team.id) &&
                    !this.managed_teams.some(mTeam => mTeam.id === team.id)
                );
            },
        },
        mounted() {
            this.detectMobile();
            window.addEventListener('resize', this.detectMobile);
            this.initializeData();
        },
        beforeDestroy() {
            window.removeEventListener('resize', this.detectMobile);
        },
        methods: {
            async initializeData() {
                await this.fetchUserData();
                await this.fetchAllTeams();
            },
            async fetchUserData() {
                try {
                    this.user = await getUser(localStorage.getItem('userID'));
                } catch (error) {
                    console.error("Failed to load user data:", error);
                }
            },
            async fetchAllTeams() { 
                try {
                    const response = await getTeams();
                    // Check if the response is an array before assigning
                    if (Array.isArray(response)) {
                        this.teams = response;
                    } else {
                        console.error("Invalid response data:", response);
                        this.teams = []; // Ensure teams is still an array
                    }
                    await this.fetchTeamDetails();
                } catch (error) {
                    console.error("Failed to load teams:", error);
                    this.teams = []; // Ensure teams is still an array on error
                }
            },
            async fetchTeamDetails() {
                const me_teams = await meTeams();
                this.employee_teams = me_teams.employee_teams.data;
                this.managed_teams = me_teams.managing_teams.data;

                // Vérifiez si l'utilisateur est dans au moins une équipe avant de chercher les détails des managers
                if (this.employee_teams.length > 0 || this.managed_teams.length > 0) {
                    await this.fetchManagers();
                }
            },
            async fetchManagers() {
                for (let team of this.teams) {
                    const team_details = await showTeam(team.id);
                    if (team_details && team_details.managers) {
                        for (let manager of team_details.managers) {
                            const manager_details = await this.showManager(manager.id);
                            // Assurez-vous que l'objet managers[team.id] est initialisé avant de l'étendre
                            if (!this.managers[team.id]) {
                                this.managers[team.id] = {};
                            }
                            this.managers[team.id][manager.id] = manager_details;
                        }
                    }
                }
            },
            async showManager(teamID) {
                const manager = await getUser(teamID);
                return manager.username;
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
                    const teamIndex = this.teams.findIndex(team => team.id === teamId);
                    if (teamIndex !== -1) {
                        this.teams.splice(teamIndex, 1);
                    }
                    this.deleteDialog = false;
                    this.bottomSheetVisible = false;
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

                    const teamIndex = this.teams.findIndex(team => team.id === this.selectedTeam.id);
                    if (teamIndex !== -1) {
                        this.teams[teamIndex].name = this.selectedTeamName;
                    }

                    this.editDialog = false;
                    this.bottomSheetVisible = false;
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
            },
            detectMobile() {
                this.isMobile = window.innerWidth <= 1080;
            },
            showBottomSheet(item) {
                this.item = item;
                this.bottomSheetVisible = true;
            }
        }
    };
</script>

