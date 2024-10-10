<template>
    <div v-if="props.type === 'pie'">
        <Pie :datas="props.datas" />
    </div>
    <div v-else-if="props.type === 'bar'">
        <Bar :datas="props.datas" />
    </div>
    <div v-else-if="props.type === 'line'">
        <Line :datas="props.datas" />
    </div>
    <div v-else-if="props.type === 'radar'">
        <Radar :datas="props.datas" />
    </div>
    <div v-else>
        <p>No data</p>
    </div>
</template>

<script setup lang="ts">
import Pie from './charts/pie/pie.vue'
import Bar from './charts/bar/bar.vue'
import Line from './charts/line/line.vue'
import Radar from './charts/radar/radar.vue'
import type { IChartData } from '@/src/types/chart'

const props = defineProps({
  type: String,
  datas: Array<IChartData>
})
</script>