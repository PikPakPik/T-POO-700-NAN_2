import axios, { type AxiosInstance } from 'axios'


export class Api {
    private instance: AxiosInstance

    constructor() {
        this.instance = axios.create({
          baseURL: import.meta.env.VITE_API_URL,
          timeout: 1000,
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json'
          }
        })
      }
}