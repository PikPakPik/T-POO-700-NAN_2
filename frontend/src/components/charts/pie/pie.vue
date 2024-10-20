<script lang="ts" setup>
import { Pie } from "vue-chartjs";
import type { IChartData } from "@/src/types/chart";
import { nextTick } from 'vue';

defineProps<{
  chartDatas: IChartData | null;
}>();

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
};

const render = ref(true);

const reRender = (fn: Function) => {
  render.value = false;
  nextTick(() => {
    fn();
    render.value = true;
  });
};

defineExpose({
  reRender,
});
</script>
<template>
  <div v-if="render && chartDatas">
    <Pie :data="chartDatas" :options="chartOptions" />
  </div>
  <template v-else>
    <div>
      <p>No data</p>
    </div>
  </template>
</template>