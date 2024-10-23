<template>
  <div class="flex flex-col gap-2 index-intro mb-8" data-title="Date du jour" data-intro="Voici la date du jour">
    <h1 class="text-4xl">
      Aujourd'hui
    </h1>
    <h2 class="text-lg">
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
    this.updateDateTime();
    setInterval(this.updateDateTime, 60000);
  },
  methods: {
    updateDateTime() {
      const now = new Date();
      const options = {
        weekday: 'short',
        day: '2-digit',
        month: 'long',
      };
      let formattedDate = now.toLocaleDateString('fr-FR', options);
      let formattedTime = now.toLocaleTimeString('fr-FR', {
        hour: '2-digit',
        minute: '2-digit'
      });

      formattedDate = formattedDate.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
      formattedTime = formattedTime.split(':').map((part, index) => index === 0 ? part.charAt(0).toUpperCase() + part.slice(1) : part).join(':');

      this.displayDate = `${formattedDate} | ${formattedTime}`;
    }
  }
};
</script>
