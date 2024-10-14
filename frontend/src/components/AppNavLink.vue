<template>
  <RouterLink
    :to="to"
    activeClass="active"
    :class="`flex items-center space-x-2 p-2 rounded-lg ${
      active ? 'bg-gray-900 text-white' : 'text-gray-600 hover:bg-gray-200'
    } ${!isOpen ? 'justify-center' : ''}`"
  >
    <slot />
    <span class="ml-6" v-if="isOpen">{{ label }}</span>
  </RouterLink>
</template>

<script setup>
import { ref } from 'vue'
import { RouterLink } from 'vue-router'

const props = defineProps({
  to: String,
  label: String,
  active: Boolean,
  isOpen: Boolean
})
</script>