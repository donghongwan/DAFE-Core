// src/utils/api.js
import axios from 'axios';

const API_BASE_URL = 'https://your-api-url.com'; // Replace with your API base URL

const apiClient = axios.create({
    baseURL: API_BASE_URL,
    timeout: 10000, // Set a timeout for requests
});

// Function to handle GET requests
export const get = async (endpoint) => {
    try {
        const response = await apiClient.get(endpoint);
        return response.data;
    } catch (error) {
        console.error("API GET error:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// Function to handle POST requests
export const post = async (endpoint, data) => {
    try {
        const response = await apiClient.post(endpoint, data);
        return response.data;
    } catch (error) {
        console.error("API POST error:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// You can add more methods (PUT, DELETE) as needed
