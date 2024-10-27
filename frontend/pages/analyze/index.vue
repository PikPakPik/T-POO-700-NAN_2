<template>
  <v-container class="mx-auto max-w-screen-lg px-4 py-8 sm:px-8 intro-index" data-title="Espace analyse"
    data-intro="Vous pourrez y retrouver des graphiques d'analyse de vos heures de travail">

    <v-row class="flex items-center justify-center pb-6">
      <v-col class="text-center">
        <h2 class="font-semibold text-gray-700">Analyse</h2>
        <span class="text-xs text-gray-500">Afficher des graphiques d'analyse</span>
      </v-col>
    </v-row>
    <v-row class="flex flex-col items-center justify-center pb-6 gap-4">
      <h2 class="text-sm text-gray-500">Voir en :</h2>
      <div class="flex gap-2" data-intro="Voir les heures de jour et de nuit par semaine, mois ou année">
        <v-btn @click="setThisWeek" :variant="state.type === 'week' ? 'outlined' : 'text'">
          Semaine
        </v-btn>
        <v-btn @click="setThisMonth" :variant="state.type === 'month' ? 'outlined' : 'text'">
          Mois
        </v-btn>
        <v-btn @click="setThisYear" :variant="state.type === 'year' ? 'outlined' : 'text'">
          Année
        </v-btn>
      </div>
      <div data-intro="Voir les semaines, mois ou années précédentes ou suivantes">
        <div v-if="state.type === 'week'" class="flex gap-2">
          <v-btn @click="setPrevious">Semaine précédente</v-btn>
          <v-btn @click="setThisWeek">Cette semaine</v-btn>
          <v-btn @click="setNext">Semaine suivante</v-btn>
        </div>
        <div v-if="state.type === 'month'" class="flex gap-2">
          <v-btn @click="setPrevious">Mois précédent</v-btn>
          <v-btn @click="setThisMonth">Ce mois</v-btn>
          <v-btn @click="setNext">Mois suivant</v-btn>
        </div>
        <div v-if="state.type === 'year'" class="flex gap-2">
          <v-btn @click="setPrevious">Année précédente</v-btn>
          <v-btn @click="setThisYear">Cette année</v-btn>
          <v-btn @click="setNext">Année suivante</v-btn>
        </div>
      </div>
    </v-row>
    <v-row class="flex flex-col items-center justify-center pb-6">
      <h2 class="text-sm text-gray-500">Dates affichées : {{ state.currentTypeDates.title }}</h2>
      <v-col data-intro="Choisir le type de graphique">
        <v-select v-model="selectedChartType" :items="chartTypes" label="Type de graphique" class="w-1/12" />
        <chartManager :type="selectedChartType" :datas="state.chartData" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { reactive, onMounted } from 'vue'
import chartManager from '~/src/components/chartManager.vue'
import type { IChartData } from '~/src/types/chart'
import dayjs from 'dayjs'
import 'dayjs/locale/fr'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import utc from 'dayjs/plugin/utc'
import { calculateWorkingHours } from '~/src/utils/workingtimes/calculateWorkingHours'
import { meWorkingTimesDated } from '~/src/utils/api/me'


definePageMeta({
  middleware: ['global-role'],
  meta: {
    roles: ['Admin', 'Manager', 'Employee'], // Rôles requis pour accéder à cette page
  },
})

dayjs.extend(customParseFormat)
dayjs.extend(utc)
dayjs.locale('fr')

const chartTypes = ['bar', 'line', 'pie', 'radar']
const selectedChartType = ref('bar')


const monthNames = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];

const state = reactive({
  chartData: { labels: [], datasets: [] } as IChartData,
  type: 'week',
  currentTypeDates: { title: '' }
})

async function updateChartData(startDate: Date, endDate: Date) {
  const rawData = await meWorkingTimesDated(dayjs(startDate).utc().toISOString(), dayjs(endDate).utc().toISOString());

  const { dayHours, nightHours } = processWorkingHours(rawData?.data, startDate, endDate);

  state.chartData.datasets = [
    { label: 'Heures de jour', data: dayHours, backgroundColor: 'rgba(75, 192, 192, 0.2)' },
    { label: 'Heures de nuit', data: nightHours, backgroundColor: 'rgba(255, 99, 132, 0.2)' }
  ];
}

function processWorkingHours(data: any[], startDate: Date, endDate: Date) {
  const periodType = getPeriodType(startDate, endDate);
  const periodCount = getPeriodCount(startDate, endDate, periodType);
  const dayHours: number[] = new Array(periodCount).fill(0);
  const nightHours: number[] = new Array(periodCount).fill(0);

  data?.forEach(entry => {
    const { dayHoursPerDate, nightHoursPerDate } = calculateWorkingHours(entry.start, entry.end);
    Object.entries(dayHoursPerDate).forEach(([date, hours]) => {
      const index = getPeriodIndex(date, startDate, periodType);
      if (index >= 0 && index < periodCount) {
        dayHours[index] += hours;
        nightHours[index] += nightHoursPerDate[date] || 0;
      }
    });
  });

  return { dayHours, nightHours };
}

function getPeriodType(startDate: Date, endDate: Date): 'day' | 'week' | 'month' {
  const dayDifference = dayjs(endDate).diff(dayjs(startDate), 'day');
  if (dayDifference <= 7) return 'day';
  if (dayDifference <= 31) return 'week';
  return 'month';
}

function getPeriodCount(startDate: Date, endDate: Date, periodType: 'day' | 'week' | 'month'): number {
  return dayjs(endDate).diff(dayjs(startDate), periodType) + 1;
}

function getPeriodIndex(date: string, startDate: Date, periodType: 'day' | 'week' | 'month'): number {
  const currentDate = dayjs(date);
  const start = dayjs(startDate);

  switch (periodType) {
    case 'day':
      return currentDate.diff(start, 'day');
    case 'week':
      return Math.floor(currentDate.diff(start, 'day') / 7);
    case 'month':
      return currentDate.diff(start, 'month');
    default:
      return 0;
  }
}

const setPeriod = (periodType: 'week' | 'month' | 'year', direction: 'this' | 'previous' | 'next') => {
  state.type = periodType
  let currentDate;

  if (direction === 'this') {
    currentDate = dayjs();
  } else {
    const [startDateStr] = state.currentTypeDates.title.split(' -> ');
    const [day, month, year] = startDateStr.split(' ');
    const monthIndex = monthNames.findIndex(m => m.toLowerCase() === month.toLowerCase());
    if (monthIndex !== -1) {
      currentDate = dayjs(`${year}-${String(monthIndex + 1).padStart(2, '0')}-${day}`);
    } else {
      currentDate = dayjs();
    }
  }

  let startDate, endDate

  if (direction === 'previous') {
    startDate = currentDate.subtract(1, periodType).startOf(periodType)
  } else if (direction === 'next') {
    startDate = currentDate.add(1, periodType).startOf(periodType)
  } else {
    startDate = currentDate.startOf(periodType)
  }

  endDate = startDate.endOf(periodType)

  state.currentTypeDates.title = `${startDate.format('DD MMMM YYYY')} -> ${endDate.format('DD MMMM YYYY')}`

  updateChartData(startDate.toDate(), endDate.toDate())
  updateLabelsByDateRange(startDate.toDate(), endDate.toDate())
}

function updateLabelsByDateRange(startDate: Date, endDate: Date) {
  const startDay = dayjs(startDate)
  const endDay = dayjs(endDate)
  const dayDifference = endDay.diff(startDay, 'day') + 1

  state.chartData.labels = []

  if (dayDifference <= 7) {
    state.chartData.labels = Array.from({ length: dayDifference }, (_, i) =>
      startDay.add(i, 'day').format('DD/MM/YYYY')
    )
  } else if (dayDifference <= 31) {
    const weeks = Math.ceil(dayDifference / 7)
    state.chartData.labels = Array.from({ length: weeks }, (_, i) => {
      const weekStart = startDay.add(i * 7, 'day')
      const weekEnd = weekStart.add(6, 'day').isAfter(endDay) ? endDay : weekStart.add(6, 'day')
      return `${weekStart.format('DD/MM/YYYY')} -> ${weekEnd.format('DD/MM/YYYY')}`
    })
  } else {
    const months = endDay.diff(startDay, 'month') + 1
    state.chartData.labels = Array.from({ length: months }, (_, i) => {
      const monthDate = startDay.add(i, 'month')
      return monthDate.format('MMMM YYYY').toUpperCase()
    })
  }
}

const setThisWeek = () => setPeriod('week', 'this')
const setThisMonth = () => setPeriod('month', 'this')
const setThisYear = () => setPeriod('year', 'this')
const setPrevious = () => setPeriod(state.type as 'week' | 'month' | 'year', 'previous')
const setNext = () => setPeriod(state.type as 'week' | 'month' | 'year', 'next')

onMounted(setThisWeek)
</script>
