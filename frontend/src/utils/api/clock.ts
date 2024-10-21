import { Api } from "./api";


export class ClockApi extends Api {
    constructor() {
        super()
    }
  
  async getClock(userId: number): Promise<any> {
    try {
      const response = await this.instance.get(`/clocks/${userId}`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération du clock :', error);
      throw error;
    }
  }

  async clockInOrOut(userId: number): Promise<any> {
    try {
      const response = await this.instance.post(`/clocks/${userId}`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'enregistrement du clock :', error);
      throw error;
    }
  }
      
}

export default ClockApi;