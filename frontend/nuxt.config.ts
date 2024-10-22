import path from 'path'
import vuetify, { transformAssetUrls } from 'vite-plugin-vuetify'
export default defineNuxtConfig({
  ssr: false,
  build: {
    transpile: ['vuetify'],
  },

  css: ['~/assets/css/main.css'],

  modules: [
    (_options, nuxt) => {
      nuxt.hooks.hook('vite:extendConfig', (config) => {
        // @ts-expect-error
        config.plugins.push(vuetify({ autoImport: true }))
      })
    },
    '@pinia/nuxt',
  ],

  nitro: {
    preset: 'static',
    output: {
      publicDir: path.join(__dirname, 'TimeManagerApp/www'),
    }
  },

  hooks: {
    close: (nuxt) => {
      if(!nuxt.options._prepare) process.exit()
    },
  },

  vite: {
    vue: {
      template: {
        transformAssetUrls,
      },
    },
  },

  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  app: {
    buildAssetsDir: '/nuxt/',
  },

  compatibilityDate: '2024-10-10',
})