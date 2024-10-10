import axios, { type AxiosInstance } from 'axios'


export class Api {
    protected instance: AxiosInstance

    constructor() {
        this.instance = axios.create({
          baseURL: 'http://localhost:4000/api',
          timeout: 1000,
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json'
          }
        })
      }
}