import { Api } from "./api";


export class ClockApi extends Api {
    constructor() {
        super()
    }

    async startWorking(userId: number, startTime: string, status: boolean): Promise<any> {
        try {
          const response = await this.instance.post(`/clocks/${userId}`, {
            clock: { 
              time: startTime,
              status : true,
             },
          });
          return response.data;
        } catch (error) {
          console.error('Erreur lors de l\'envoie du clock :', error);
          throw error;
        }
      }

      async endWorking(userId: number, endTime: string, status: boolean): Promise<any> {
        try {
          
          const response = await this.instance.get(`/clocks/${userId}`);
          
          const clocks = response.data.data;

          const clock = clocks[0];

          const startTime = clock.time; 
    
          const workingTimeData = {
            working_time: {
              start: startTime,
              end: endTime
            }
          };
    
          const postResponse = await this.instance.post(`/workingtime/${userId}`, workingTimeData);
    
          return postResponse.data;
        
          } catch (error) {
            console.error('Erreur lors de l\'opération endWorking :', error);
            throw error;
          }
      }
      
}

export default ClockApi;