import {instance} from "@/main.js";

export async function get_user() {
    return await instance.get('/get',)
}

export async function set_user() {
    return await instance.get('/set',)
}