import axios, { type AxiosInstance } from 'axios'


export class Api {
    protected instance: AxiosInstance

    constructor() {
        this.instance = axios.create({
          baseURL: import.meta.env.MODE === 'development' ? import.meta.env.VITE_BACKEND_URL + '/api' : 'https://time-manager-api-nan-2-main.onrender.com/api',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json'
          }
        })
      }
}