<script lang="ts" setup>
import { Radar } from "vue-chartjs";
import type { IChartData } from "@/src/types/chart";
import { nextTick } from 'vue';

defineProps<{
  datas: IChartData | null;
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
  <div v-if="render && datas">
    <Radar :data="datas" :options="chartOptions" />
  </div>
  <template v-else>
    <div>
      <p>No data</p>
    </div>
  </template>
</template>