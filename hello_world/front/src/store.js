import {createStore} from "vuex";
import avatar from '@/img/avatar.png';

const store = createStore({
    state: {
        user: {
            username: 'JohnDoe',
            fullName: 'John Doe',
            login: 'johndoe',
            icon: "",
            point: ""
        },
    },
    mutations: {
        SET_USERNAME(state, username) {
            state.user.username = username;
        },
        SET_FULLNAME(state, fullName) {
            state.user.fullName = fullName;
        },
        SET_LOGIN(state, login) {
            state.user.login = login;
        },
        SET_PASSWORD(state, password) {
            // В реальном приложении здесь должна быть логика для обновления пароля на сервере
            console.log('Password updated', password);
        },
        SET_ICON(state, iconUrl) {
            state.user.icon = iconUrl;
        },
        SET_POINT(state, point) {
            state.user.point = point;
        },
    },
    getters: {
        getUser: state => state.user,
    },
});

export default store
