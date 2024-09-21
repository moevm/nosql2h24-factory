import { createRouter, createWebHistory } from 'vue-router';
import UserProfile from './components/user_page/UserProfile.vue';
import App from "@/App.vue";

const routes = [
    {
        path: '/',
        name: 'UserProfile',
        component: UserProfile,
    },
    {
        path: '/profile',
        name: 'UserProfile',
        component: UserProfile,
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
