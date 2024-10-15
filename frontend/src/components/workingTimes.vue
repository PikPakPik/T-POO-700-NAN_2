<template>
    <v-container>
        <v-row justify="start">
            <v-col cols="12">
                <v-card class="transparent-card">
                    <v-alert v-if="error" type="error" class="mt-4">
                        {{ error }}
                    </v-alert>
                    <v-alert v-if="message" type="success" class="mt-4">
                        {{ message }}
                    </v-alert>
                    <v-card-title class="d-flex justify-space-between align-center">
                        <v-text-field v-model="search" class="search-bar" append-icon="mdi-magnify" label="Search"
                            single-line hide-details></v-text-field>
                        <v-btn icon class="mr-2 blue" @click="openCreateDialog()">
                            <v-icon>mdi-plus</v-icon>
                        </v-btn>
                    </v-card-title>
                    <v-data-table :headers="headers" :items="workingTimes" :search="search" item-key="id"
                        class="elevation-1 custom-data-table" items-per-page-text="Élément par page"
                        :items-per-page="itemsPerPage" :page.sync="page" :footer-props="customFooterProps"
                        :items-per-page-options="options.itemsPerPageOptions">
                        <template v-slot:item.date="{ item }">
                            {{ formatDate(item) }}
                        </template>
                        <template v-slot:item.start="{ item }">
                            {{ formatStart(item) }}
                        </template>
                        <template v-slot:item.end="{ item }">
                            {{ formatEnd(item) }}
                        </template>
                        <template v-slot:item.workingTimePoster="{ item }">
                            {{ formatWorkingTimePoster(item) }}
                        </template>
                        <template v-slot:item.action="{ item }">
                            <v-row class="d-flex align-center flex-row no-gutters">
                                <v-btn icon size="small" class="mr-2" @click="openEditDialog(item)">
                                    <v-icon>mdi-pencil</v-icon>
                                </v-btn>
                                <v-btn icon size="small" class="mr-2" @click="confirmDelete(item)">
                                    <v-icon>mdi-trash-can</v-icon>
                                </v-btn>
                            </v-row>
                        </template>
                    </v-data-table>
                </v-card>
            </v-col>
        </v-row>
        <!-- Confirmation Dialog -->
        <v-dialog v-model="dialog" max-width="500" class="custom-dialog">
            <v-card>
                <v-toolbar flat class="custom-toolbar">
                    <v-toolbar-title class="white--text custom-title">Confirmer la suppression</v-toolbar-title>
                    <v-btn icon @click="dialog = false">
                        <v-icon class="white--text">mdi-close</v-icon>
                    </v-btn>
                </v-toolbar>
                <v-divider></v-divider>
                <v-card-text>Êtes-vous sûr de vouloir supprimer cet élément ?</v-card-text>
                <v-divider></v-divider>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="red darken-1" text @click="deleteItem">
                        <v-icon left>mdi-delete</v-icon> Supprimer
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Edit Dialog -->
        <v-dialog v-model="editDialog" max-width="600">
            <working-time :userID="userID" :workingTimeID="itemToEdit.id" @close="editDialog = false"
                @updated="handleSuccess" @error="handleError"></working-time>
        </v-dialog>
        <v-dialog v-model="createDialog" max-width="600">
            <working-time :userID="userID" @close="createDialog = false" @created="handleSuccess"
                @error="handleError"></working-time>
        </v-dialog>
    </v-container>
</template>

<script>
import WorkingTime from './WorkingTime.vue';
import { readWorkingTimes, deleteWorkingTime } from '@/src/utils/api/workingtime.ts'

export default {
    name: 'workingTimes',
    components: {
        WorkingTime
    },
    data() {
        return {
            workingTimes: [],
            search: '',
            headers: [
                { title: 'Date(s)', text: 'Date(s)', sortable: true, value: 'date' },
                { title: 'Heure de début', text: 'Heure de début', sortable: true, value: 'start' },
                { title: 'Heure de fin', text: 'Heure de fin', sortable: true, value: 'end' },
                { title: 'Temps travaillé (nuit)', text: 'Temps travaillé (nuit)', sortable: true, value: 'workingTimePoster' },
                { title: 'Actions', text: 'Actions', sortable: false, value: 'action' },
            ],
            error: null,
            message: null,
            dialog: false,
            editDialog: false,
            createDialog: false,
            itemToDelete: null,
            itemToEdit: null,
            page: 1,
            itemsPerPage: 10,
            options: {
                'items-per-page-options': [10, 20, 30, { text: 'Tous', value: -1 }],
                'items-per-page-text': 'Élément par page',
                'page-text': this.pageText
            }
        }
    },
    props: {
        userID: {
            type: String,
            default: '',
        },
    },
    computed: {
        formatDate() {
            return (workingTime) => {
                const startDate = workingTime.start.split('T')[0].split('-').reverse().join('/');
                const endDate = workingTime.end.split('T')[0].split('-').reverse().join('/');
                if (startDate === endDate) {
                    return startDate;
                }
                return startDate + ' - ' + endDate;
            };
        },
        formatStart() {
            return (workingTime) => {
                return workingTime.start.split('T')[1].split(':').slice(0, 2).join(':');
            };
        },
        formatEnd() {
            return (workingTime) => {
                return workingTime.end.split('T')[1].split(':').slice(0, 2).join(':');
            };
        },
        formatWorkingTimePoster() {
            return (workingTime) => {
                return this.time(workingTime) + ' (' + this.timeNight(workingTime) + ')';
            };
        },
        pageStart() {
            return (this.page - 1) * this.itemsPerPage + 1;
        },
        pageStop() {
            return Math.min(this.page * this.itemsPerPage, this.workingTimes.length);
        },
        itemsLength() {
            return this.workingTimes.length;
        },
        customFooterProps() {
            return {
                'items-per-page-options': [10, 20, 30, { text: 'Tous', value: -1 }],
                'items-per-page-text': 'Élément par page',
                'page-text': this.pageText
            };
        },
        pageText() {
            const pageStart = (this.page - 1) * this.itemsPerPage + 1;
            const pageStop = Math.min(this.page * this.itemsPerPage, this.workingTimes.length);
            const itemsLength = this.workingTimes.length;
            return `${pageStart}-${pageStop} sur ${itemsLength}`;
        },
    },
    mounted() {
        this.getWorkingTimes();
    },
    methods: {
        getWorkingTimes() {
            readWorkingTimes(this.userID)
                .then(response => {
                    this.workingTimes = response.data.sort((a, b) => {
                        return new Date(a.start) - new Date(b.start);
                    });
                })
                .catch(error => {
                    console.error('Error selecting working time:', error);
                });
        },
        time(workingTime) {
            const start = new Date(workingTime.start);
            const end = new Date(workingTime.end);
            const diff = end - start;
            const hours = Math.floor(diff / 1000 / 60 / 60);
            const minutes = Math.floor(diff / 1000 / 60) - hours * 60;
            if (minutes === 0) {
                return hours + 'h';
            }
            return hours + 'h' + minutes;
        },
        // Return time working between 21:00 and 06:00
        timeNight(workingTime) {
            const start = new Date(workingTime.start);
            const end = new Date(workingTime.end);

            let nightHours = 0;
            let nightMin = 0;

            // Iterate through each hour between start and end
            for (let d = new Date(start); d <= end; d.setHours(d.getHours() + 1)) {
                const hour = d.getHours();
                if (hour >= 21 || hour < 6) {
                    if (d.getTime() === start.getTime()) {
                        nightMin += 60 - d.getMinutes();
                    }
                    else if (d.getTime() === end.getTime()) {
                        nightMin += d.getMinutes();
                    } else {
                        nightHours++;
                    }
                }
            }

            if (nightMin === 0) {
                return nightHours + 'h';
            } else {
                const hours = nightHours + Math.floor(nightMin / 60);
                const remainingMinutes = nightMin % 60;
                if (remainingMinutes === 0) {
                    return hours + 'h';
                } else {
                    return hours + 'h' + remainingMinutes + 'm';
                }
            }
        },
        openCreateDialog() {
            this.createDialog = true;
        },
        openEditDialog(item) {
            this.itemToEdit = item;
            this.editDialog = true;
        },
        confirmDelete(item) {
            this.itemToDelete = item;
            this.dialog = true;
        },
        handleSuccess(message) {
            this.dialog = false;
            this.createDialog = false;
            this.editDialog = false;
            this.getWorkingTimes();
            this.$emit('success', message);
        },
        handleError(message) {
            this.dialog = false;
            this.createDialog = false;
            this.editDialog = false;
            this.$emit('error', message);
        },
        deleteItem() {
            deleteWorkingTime(this.itemToDelete.id)
                .then(() => {
                    this.getWorkingTimes();
                    this.message = 'Working time supprimé';
                    this.dialog = false;
                })
                .catch(error => {
                    this.error = 'Erreur : impossible de supprimer le working time';
                    this.dialog = false;
                });
        },
    }
}
</script>

<style scoped>
.blue {
    color: #FFC107;
}

.search-bar {
    max-width: 400px;
}

.v-card {
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.custom-dialog .v-card {
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.custom-toolbar {
    background-color: #FFC107;
    /* Amber color */
    border-top-left-radius: 12px;
    border-top-right-radius: 12px;
    border-radius: inherit;
}

.v-card-actions {
    justify-content: flex-end;
}

.transparent-card {
    background-color: transparent !important;
    box-shadow: none !important;
}

:deep(.v-data-table) thead {
    background-color: #FFC107 !important;
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
</style>