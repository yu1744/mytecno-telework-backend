// @/app/lib/api.ts

import axios from 'axios';
import Cookies from 'js-cookie';

const api = axios.create({
  baseURL: 'http://localhost:3001', 
  headers: {
    'Content-Type': 'application/json',
  },
});


api.interceptors.request.use(
  (config) => {
    const accessToken = Cookies.get('access-token');
    const client = Cookies.get('client');
    const uid = Cookies.get('uid');

    if (accessToken && client && uid) {
      config.headers['access-token'] = accessToken;
      config.headers['client'] = client;
      config.headers['uid'] = uid;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);


api.interceptors.response.use(
  (response) => {
    const newAccessToken = response.headers['access-token'];
    const newClient = response.headers['client'];
    const newUid = response.headers['uid'];

    if (newAccessToken && newClient && newUid) {
      Cookies.set('access-token', newAccessToken);
      Cookies.set('client', newClient);
      Cookies.set('uid', newUid);
    }
    return response;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default api;