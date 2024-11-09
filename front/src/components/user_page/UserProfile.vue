<template>
  <v-banner-text v-if="loaded && !loadedOK">Network error</v-banner-text>
  <v-banner-text v-if="!loaded">Loading...</v-banner-text>
  <v-container v-if="loaded && loadedOK" class="user-profile" max-width="400px">
    <v-row>
      <v-col cols="12">
        <h2>User Profile</h2>

        <!-- Profile Picture -->
        <v-row class="profile-picture">
          <v-col cols="12">
            <v-img
                :src="getImageSrc(user.icon)"
                alt="User Icon"
                max-width="100"
                max-height="100"
                class="rounded-circle"
                contain
            ></v-img>
            <v-file-input
                label="Change Icon"
                @change="onIconChange"
                prepend-icon="mdi-camera"
            ></v-file-input>
          </v-col>
        </v-row>

        <!-- Username -->
        <v-row class="profile-field">
          <v-col cols="12">
            <v-text-field
                label="Username"
                v-model="user.username"
                outlined
            ></v-text-field>
            <v-btn @click="" color="primary">Change Username</v-btn>
          </v-col>
        </v-row>

        <!-- Full Name -->
        <v-row class="profile-field">
          <v-col cols="12">
            <v-text-field
                label="Full Name"
                v-model="user.fullName"
                outlined
            ></v-text-field>
            <v-btn @click="" color="primary">Change Name</v-btn>
          </v-col>
        </v-row>

        <!-- Login -->
        <v-row class="profile-field">
          <v-col cols="12">
            <v-text-field
                label="Login"
                v-model="user.login"
                outlined
            ></v-text-field>
            <v-btn @click="" color="primary">Change Login</v-btn>
          </v-col>
        </v-row>

        <!-- Password -->
        <v-row class="profile-field">
          <v-col cols="12">
            <v-text-field
                label="Password"
                v-model="password"
                outlined
                type="password"
            ></v-text-field>
            <v-btn @click="" color="primary">Change Password</v-btn>
          </v-col>
        </v-row>
        <v-banner-text>Influx point:</v-banner-text>
        <v-banner-text>{{ user.point}}</v-banner-text>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>

import {get_user, set_user} from "@/requests/profile_requests.js";

export default {
  data() {
    return {
      password: '',
      user: this.$store.getters.getUser,
      loaded: false,
      loadedOK: false
    };
  },
  methods: {
    async fetchUserProfile() {
      try {
        const response1 = await set_user();
        const response = await get_user();
        if(response1.status === 200 && response.status === 200) {
          console.log(response.data)
          this.$store.commit('SET_USERNAME', response.data.username);
          this.$store.commit('SET_FULLNAME', response.data.full_name);
          this.$store.commit('SET_LOGIN', response.data.login);
          console.log(response.data.point)
          this.$store.commit('SET_POINT', response.data.point);
          this.$store.commit('SET_ICON', response.data.icon || '');
          this.loadedOK = true
        }
        this.loaded = true
      } catch (error) {
        console.error('Failed to fetch user data', error);
      }
    },
    getImageSrc(icon) {
      if (icon && !icon.startsWith('data:image')) {
        return `data:image/png;base64,${icon}`;
      }
      return icon;
    },
    onIconChange(event) {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.$store.commit('SET_ICON', e.target.result.split(',')[1]);
        };
        reader.readAsDataURL(file);
      }
    }
  },
  set_user_comp(){
    set_user();
  },
  created() {
    this.fetchUserProfile(); // Загружаем данные пользователя при открытии страницы
  }
};
</script>

<style scoped>
.user-profile {
  max-width: 400px;
  margin: 0 auto;
}

.profile-picture img {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
}

.profile-field {
  margin-bottom: 20px;
}
</style>
