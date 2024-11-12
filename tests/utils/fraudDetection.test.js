// tests/utils/fraudDetection.test.js
const { isFraudulentTransaction, detectFraud } = require('../../src/utils/fraudDetection');

describe('Fraud Detection Functions', () => {
    describe('isFraudulentTransaction', () => {
        test('should return true for transactions above the threshold', () => {
            const transaction = { id: 1, value: 10000 };
            const threshold = 5000;
            const result = isFraudulentTransaction(transaction, threshold);
            expect(result).toBe(true);
        });

        test('should return false for transactions below the threshold', () => {
            const transaction = { id: 2, value: 3000 };
            const threshold = 5000;
            const result = isFraudulentTransaction(transaction, threshold);
            expect(result).toBe(false);
        });
    });

    describe('detectFraud', () => {
        test('should return an array of fraudulent transactions', () => {
            const transactions = [
                { id: 1, value: 10000 },
                { id: 2, value: 3000 },
                { id: 3, value: 7000 },
            ];
            const threshold = 5000;
            const fraudulentTransactions = detectFraud(transactions, threshold);
            expect(fraudulentTransactions).toEqual([
                { id: 1, value: 10000 },
                { id: 3, value: 7000 },
            ]);
        });

        test('should return an empty array if no fraudulent transactions', () => {
            const transactions = [
                { id: 1, value: 3000 },
                { id: 2, value: 4000 },
            ];
            const threshold = 5000;
            const fraudulentTransactions = detectFraud(transactions, threshold);
            expect(fraudulentTransactions).toEqual([]);
        });
    });
});
