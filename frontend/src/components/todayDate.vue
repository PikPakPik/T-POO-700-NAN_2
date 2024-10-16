<template>
  <div class="flex flex-col">
    <h1 class="text-2xl">
      AUJOURD'HUI
    </h1>
    <h2>
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

