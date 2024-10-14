<template>
    <v-app>
        <v-navigation-drawer
        v-model="drawer"
        app
        >
        <v-list dense>
            <v-list-item
            v-for="item in items"
            :key="item.title"
            link
            >
            <v-list-item-icon>
                <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
                <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
            </v-list-item>
        </v-list>
        </v-navigation-drawer>
    </v-app>
  </template>
  
  <script>
  export default {
    data: () => ({
      drawer: null,
      items: [
        { title: 'Home', icon: 'mdi-home' },
        { title: 'About', icon: 'mdi-information' },
      ],
    }),
  }
  </script>