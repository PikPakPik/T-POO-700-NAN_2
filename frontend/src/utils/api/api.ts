import axios, { type AxiosInstance } from 'axios'


export class Api {
    protected instance: AxiosInstance

    constructor() {
        axios.defaults.withCredentials = true;
        axios.defaults.headers.common['Access-Control-Allow-Origin'] = '*';  // ou configurer l'origine spécifique
        this.instance = axios.create({
          baseURL: 'http://localhost:4000',
          timeout: 1000,
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json'
          }
        })
      }
}