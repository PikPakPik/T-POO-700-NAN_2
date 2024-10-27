import { defineStore } from 'pinia';

export const useChronoStore = defineStore('chrono', {
  state: () => ({
    timeElapsed: 0,
    isPlaying:false
  }),
  actions: {
    updateTimeElapsed(time : number) {
      this.timeElapsed = time;
      this.isPlaying = true;
    },
    updateIsPlaying(value : boolean){
      this.isPlaying = value;
    },
    reset() {
      this.timeElapsed = 0;
      this.isPlaying = false;
    }
  },
  getters: {
    getTimeElapsed: (state) => state.timeElapsed,
    getIsPlaying : (state) => state.isPlaying
  },
});
