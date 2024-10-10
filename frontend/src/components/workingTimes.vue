<template>
    <v-container>
        <v-row justify="center">
            <v-col cols="12" md="8">
                <v-card>
                    <v-card-title>
                        <v-text-field v-model="search" append-icon="mdi-magnify" label="Search" single-line
                            hide-details></v-text-field>
                    </v-card-title>
                    <v-data-table :headers="headers" :items="workingTimes" :search="search" item-key="id"
                        class="elevation-1">
                    </v-data-table>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>
import { readWorkingTime } from '@/src/utils/api/workingtime.ts'

export default {
    name: 'workingTimes',
    data() {
        return {
            workingTimes: [],
            search: '',
            headers: [
                { title: 'Start Time', text: 'Start Time', sortable: true, value: 'start' },
                { title: 'End Time', text: 'End Time', sortable: true, value: 'end' },
            ],
        }
    },
    props: {
        userID: {
            type: String,
            default: '',
        },
    },

    mounted() {
        this.getWorkingTimes();
    },

    methods: {
        getWorkingTimes() {
            readWorkingTime(this.userID)
                .then(response => {
                    this.workingTimes = response.data.sort((a, b) => {
                        return new Date(a.start) - new Date(b.start);
                    });
                })
                .catch(error => {
                    console.error('Error selecting working time:', error);
                });
        },
    }
}
</script>

<style scoped>
.v-card-title {
    display: flex;
    justify-content: center;
}
</style>