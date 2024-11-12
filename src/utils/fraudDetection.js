// src/utils/fraudDetection.js

// Function to detect suspicious transactions based on amount
export const isSuspiciousTransaction = (amount) => {
    const THRESHOLD = 10000; // Set a threshold for suspicious transactions
    return amount > THRESHOLD;
};

// Function to detect multiple transactions from the same address in a short time
export const isRapidTransactions = (transactions) => {
    const TIME_LIMIT = 60000; // 1 minute in milliseconds
    const now = Date.now();
    const recentTransactions = transactions.filter(tx => (now - tx.timestamp) < TIME_LIMIT);
    return recentTransactions.length > 5; // More than 5 transactions in 1 minute
};

// Function to validate transaction data
export const validateTransactionData = (transaction) => {
    const { recipient, amount } = transaction;
    if (!recipient || !amount || amount <= 0) {
        return false; // Invalid transaction data
    }
    return true; // Valid transaction data
};

// You can add more fraud detection functions as needed
