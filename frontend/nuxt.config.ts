import path from 'path'
import vuetify, { transformAssetUrls } from 'vite-plugin-vuetify'
export default defineNuxtConfig({
  ssr: false,
  build: {
    transpile: ['vuetify'],
  },

  modules: [
    (_options, nuxt) => {
      nuxt.hooks.hook('vite:extendConfig', (config) => {
        // @ts-expect-error
        config.plugins.push(vuetify({ autoImport: true }))
      })
    },
    '@pinia/nuxt',
  ],

  css: [
    '~/assets/css/main.css',
    'vue3-toastify/dist/index.css' // Add this line
  ],

  plugins: [
    '~/plugins/permissions.ts',
    '~/plugins/auth.ts'
  ],

  nitro: {
    preset: process.env.MODE === 'production' ? 'static' : undefined,
    output: process.env.MODE === 'development' ? {
      publicDir: path.join(__dirname, 'TimeManagerApp/www'),
    }
      : undefined,
  },

  hooks: {
    close: (nuxt) => {
      if (!nuxt.options._prepare) process.exit()
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