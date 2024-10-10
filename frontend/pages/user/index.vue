<template>
    <div class="register-container">
        <h1>Register</h1>
        <form @submit.prevent="registerUser" class="register-form">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" v-model="username" placeholder="Titi" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" v-model="email" placeholder="grominet@mail.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" v-model="password" placeholder="°°°°°°°°°°" required>
            </div>
            <button type="submit" class="register-button">Register</button>
        </form>
    </div>
</template>


<script>
import { UserApi } from '~/src/utils/api/user';

const userApi = new UserApi();

export default {
    data() {
        return {
            username: '',
            email: '',
            password: ''
        }
    },
    methods: {
        async registerUser() {
            try {
                await userApi.createUser({
                    username: this.username,
                    email: this.email,
                    password: this.password
                });
                console.log('User registered successfully');
                this.$router.push('/user');
            } catch (error) {
                console.error(error);
            }
        }
    }
}
</script>
    
<style scoped>
    .register-container {
        max-width: 400px;
        margin: 40px auto;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        background-color: #f9f9f9;
    }
    
    .register-form {
        display: flex;
        flex-direction: column;
    }
    
    .form-group {
        margin-bottom: 15px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    
    .form-group input {
        width: 100%;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    
    .register-button {
        padding: 10px;
        border: none;
        border-radius: 5px;
        background-color: #007bff;
        color: white;
        font-size: 16px;
        cursor: pointer;
    }
    
    .register-button:hover {
        background-color: #0056b3;
    }
</style>