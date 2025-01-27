import axios from 'axios';

export const actions = {
  async createEvolutionInstance({ commit }, { name }) {
    try {
      const headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json, text/plain, */*'
      };

      const response = await axios.post(
        `/api/v1/accounts/6/inboxes/evolution`,
        { name },
        { 
          headers,
          withCredentials: true
        }
      );

      return response.data;
    } catch (error) {
      return Promise.reject(error.response?.data?.error || error);
    }
  },
};