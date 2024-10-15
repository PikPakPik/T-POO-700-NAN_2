import { defineStore } from 'pinia'

export const useHeaderFacadeStore = defineStore({
  id: 'headerFacade',
  state: () => ({
    title: 'TimeManager',
  }),
  actions: {
    setTitle(title: string) {
      this.title = title
    }
  }
})
