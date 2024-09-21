import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import store from "@/store.js";
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import axios from 'axios';

const vuetify = createVuetify({
    components,
    directives,
})
export const instance = axios.create({
    baseURL: 'http://localhost:8080',
});

export default vuetify;

createApp(App).use(vuetify).use(router).use(store).mount('#app')
