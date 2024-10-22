<template>
    <div v-if="props.type === 'pie'">
        <div v-if="props.datas">
            <!-- Ajout d'une clé pour forcer la mise à jour -->
            <Pie :chartDatas="props.datas" :key="componentKey" />
        </div>
    </div>
    <div v-else-if="props.type === 'bar'">
        <div v-if="props.datas">
            <Bar :chartDatas="props.datas" :key="componentKey" />
        </div>
    </div>
    <div v-else-if="props.type === 'line'">
        <div v-if="props.datas">
            <Line :chartDatas="props.datas" :key="componentKey" />
        </div>
    </div>
    <div v-else-if="props.type === 'radar'">
        <div v-if="props.datas">
            <Radar :chartDatas="props.datas" :key="componentKey" />
        </div>
    </div>
    <div v-else>
        <p>No data</p>
    </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import Pie from './charts/pie/pie.vue'
import Bar from './charts/bar/bar.vue'
import Line from './charts/line/line.vue'
import Radar from './charts/radar/radar.vue'
import type { IChartData } from '@/src/types/chart'

const props = defineProps({
  type: String,
  datas: Object as PropType<IChartData | null>
})

const componentKey = ref(0);

watch(() => props.datas, (newVal, oldVal) => {
  componentKey.value++;
}, { deep: true });
</script>
