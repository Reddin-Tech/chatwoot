import TempPollingPage from './TempPollingPage.vue';

export default [
  {
    path: 'temp',
    name: 'settings_inbox_temp',
    component: TempPollingPage,
    roles: ['administrator', 'agent'],
  },
]; 