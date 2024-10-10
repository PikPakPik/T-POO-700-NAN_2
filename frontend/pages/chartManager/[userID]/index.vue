<template>
    <div>
        <button @click="chartType = 'pie'" class="chart-button">Pie</button>
        <button @click="chartType = 'bar'" class="chart-button">Bar</button>
        <button @click="chartType = 'line'" class="chart-button">Line</button>
        <button @click="chartType = 'radar'" class="chart-button">Radar</button>
        <ChartManager :type="chartType" :datas="data" />
    </div>
</template>

<script lang="ts">
import ChartManager from '@/src/components/chartManager.vue'
import { readWorkingTimes } from '@/src/utils/api/workingtime.ts'
import dayjs from 'dayjs';
import timezone from 'dayjs/plugin/timezone';
import utc from 'dayjs/plugin/utc';

dayjs.extend(utc);
dayjs.extend(timezone);

export default {
    name: 'ChartManagerPage',
    components: { ChartManager },
    data() {
        return {
            data: null,
            chartType: 'pie', // Type de graphique initial
        }
    },
    methods: {
        getWorkingTimes() {
            readWorkingTimes(this.userID)
                .then(response => {
                    this.data = this.convertData(response.data); 
                })
                .catch(error => {
                    console.error('Error selecting working time:', error);
                });
        },
        convertData(data) {
            const timeZone = 'Europe/Paris'; 
            return {
                labels: data.map(item => dayjs(item.start).tz(timeZone).format('YYYY-MM-DD hh:mm:ss')),
                datasets: [
                    {
                        label: data.map(item => item.start),
                        data: data.map(item => {
                            const start = dayjs(item.start).tz(timeZone);
                            const end = dayjs(item.end).tz(timeZone);
                            return end.diff(start, 'hour', true);
                        }),
                    }
                ]
            }
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
}
</script>

<style scoped>
.chart-button {
    padding: 10px 20px;
    margin: 5px;
    background-color: #f4f4f4;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.chart-button:hover {
    background-color: #e2e2e2;
}
</style>