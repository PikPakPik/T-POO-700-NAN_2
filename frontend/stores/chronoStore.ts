import { defineStore } from 'pinia';

export const useChronoStore = defineStore('chrono', {
  state: () => ({
    timeElapsed: 0,
    isPlaying:false
  }),
  actions: {
    updateTimeElapsed(time : number) {
      this.timeElapsed = time;
    },
    updateIsPlaying(value : boolean){
      this.isPlaying = value;
    }
  },
  getters: {
    getTimeElapsed: (state) => state.timeElapsed,
    getIsPlaying : (state) => state.isPlaying
  },
});
