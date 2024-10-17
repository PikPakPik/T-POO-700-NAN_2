<template>
  <div class="flex flex-col items-start bg-white shadow-md rounded-xl p-7 w-80">
    <div class="flex flex-col w-full">
      <span class="text-black text-lg font-medium">{{ title }}</span>
      <span v-if="subTitle !== ''" class="text-gray-500 italic">{{ subTitle }}</span>
    </div>
    <div class="flex items-center justify-between mt-4 w-full gap-6">
      <div class="text-black text-4xl">
        {{ formattedExtraTime }}
      </div>
      <div class="p-2 flex items-center justify-center rounded-lg bg-amber-50 size-24">
        <img :src="clock" alt="clock" class="h-12 w-12"/>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue';
import clock from '@/assets/clock.svg';

const props = defineProps({
    title: {
        type: String,
        default: ''
    },
    subTitle: {
        type: String,
        default: ''
    },
    formattedExtraTime: {
        type: String,
        default: ''
    }
})
</script>

