import axios, { type AxiosInstance } from 'axios'


export class Api {
    protected instance: AxiosInstance

    constructor() {
        this.instance = axios.create({
          baseURL: import.meta.env.VITE_BACKEND_URL + '/api',
          timeout: 1000,
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json'
          }
        })
      }
}