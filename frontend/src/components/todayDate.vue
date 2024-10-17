<template>
  <div class="flex flex-col index-intro" data-title="Date du jour" data-intro="Voici la date du jour">
    <h1 class="text-4xl">
      AUJOURD'HUI
    </h1>
    <h2 class="text-xl">
      {{ displayDate }}
    </h2>
  </div>
</template>

<script>
export default {
  data() {
    return {
      displayDate: ''
    };
  },
  mounted() {

    const now = new Date();


    const options = {
      weekday: 'short',
      day: '2-digit',
      month: 'long',
    };


    const formattedDate = now.toLocaleDateString('fr-FR', options);


    const formattedTime = now.toLocaleTimeString('fr-FR', {
      hour: '2-digit',
      minute: '2-digit'
    });


    this.displayDate = `${formattedDate} | ${formattedTime}`;
  }
};
</script>
