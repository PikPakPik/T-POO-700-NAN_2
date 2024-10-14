<script setup lang="ts">
import AppSideBar from '@/src/components/appSideBar.vue';
</script>

<template>
  <section class="default-layout flex flex-col min-h-screen w-full">
    <AppSideBar />
    <main class="flex-grow">
      <slot />
    </main>
  </section>
</template>

<style lang="scss">
html {
  background: white;
}
</style>