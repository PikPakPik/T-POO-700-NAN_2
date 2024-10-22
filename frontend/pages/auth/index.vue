<template>
    <auth />
</template>

<script setup>
//components
import auth from '~/src/components/auth/auth.vue';

definePageMeta({
    layout: 'auth',
    middleware: [
        'auth',
    ],
})
</script>
