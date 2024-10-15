import '@mdi/font/css/materialdesignicons.css'

import 'vuetify/styles'
import { createVuetify, type IconProps, type IconSet } from 'vuetify'
import BatmanIcon from '@/src/components/BatmanIcon.vue'
import { aliases, mdi } from 'vuetify/iconsets/mdi'

const customIcons = { BatmanIcon }

const custom: IconSet = {
  component: (props: IconProps) =>
    h(props.tag, [h(customIcons[props.icon as keyof typeof customIcons], { class: 'v-icon__svg' })]),
}

export default defineNuxtPlugin((app) => {
  const vuetify = createVuetify({
    icons: {
      defaultSet: 'mdi',
      aliases: {
        ...aliases,
      },
      sets: {
        mdi,
        custom,
      },
    },
  })
  app.vueApp.use(vuetify)
})