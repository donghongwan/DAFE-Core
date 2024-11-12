// src/services/defiAggregator.js
import axios from 'axios';

const DEFI_AGGREGATOR_API_URL = 'https://api.defi-aggregator.com'; // Replace with the actual DeFi aggregator API URL

// Function to get the best swap rates for a given token pair
export const getBestSwapRate = async (fromToken, toToken, amount) => {
    try {
        const response = await axios.get(`${DEFI_AGGREGATOR_API_URL}/swap`, {
            params: {
                from: fromToken,
                to: toToken,
                amount,
            },
        });
        return response.data; // Return the best swap rate data
    } catch (error) {
        console.error("Error fetching best swap rate:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// Function to get liquidity pool information
export const getLiquidityPools = async (token) => {
    try {
        const response = await axios.get(`${DEFI_AGGREGATOR_API_URL}/liquidity-pools`, {
            params: {
                token,
            },
        });
        return response.data; // Return the liquidity pool data
    } catch (error) {
        console.error("Error fetching liquidity pools:", error);
        throw error; // Rethrow the error for handling in the calling function
    }
};

// You can add more functions for other DeFi functionalities as needed
