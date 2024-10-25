// src/utils/intervalManager.js
let interval: NodeJS.Timeout | null = null;

export function startInterval(callback: () => void, intervalTime: number) {
  if (!interval) {
    interval = setInterval(callback, intervalTime);
  }
}

export function stopInterval() {
  if (interval) {
    clearInterval(interval);
    interval = null;
  }
}