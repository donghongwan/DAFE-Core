// src/services/fiatService.js
import axios from 'axios';

const FIAT_SERVICE_API_URL = 'https://api.fiat-service.com'; // Replace with the actual fiat service API URL

// Function to get the current exchange rate for a given fiat currency to crypto
export const getFiatToCryptoRate = async (fiatCurrency, cryptoCurrency) => {
    try {
        const response = await axios.get(`${FIAT_SERVICE_API_URL}/exchange-rate`, {
            params: {
                fiat: fiatCurrency,
                crypto: cryptoCurrency,
            },
        });
        return response.data; // Return the exchange rate data
    } catch (error) {
        console.error("Error fetching fiat to crypto rate:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// Function to initiate a fiat on-ramp transaction
export const fiatToCryptoOnRamp = async (fiatCurrency, amount, cryptoCurrency) => {
    try {
        const response = await axios.post(`${FIAT_SERVICE_API_URL}/on-ramp`, {
            fiatCurrency,
            amount,
            cryptoCurrency,
        });
        return response.data; // Return the transaction details
    } catch (error) {
        console.error("Error during fiat on-ramp transaction:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// Function to initiate a fiat off-ramp transaction
export const cryptoToFiatOffRamp = async (cryptoCurrency, amount, fiatCurrency) => {
    try {
        const response = await axios.post(`${FIAT_SERVICE_API_URL}/off-ramp`, {
            cryptoCurrency,
            amount,
            fiatCurrency,
        });
        return response.data; // Return the transaction details
    } catch (error) {
        console.error("Error during fiat off-ramp transaction:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// You can add more functions for other fiat services as needed
