const Dashboard = resolve => require(['../components/dashboard.vue'], resolve)
const Login = resolve => require(['../components/login.vue'], resolve)

import VueRouter from 'vue-router'

export const router = new VueRouter({
  routes: [
    { path: '/', name:"root",component: Dashboard },

    { path: '/login', name:"login", component: Login },
  ]
});
