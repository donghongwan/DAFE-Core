// tests/utils/analytics.test.js
const { calculateTotalTransactions, calculateAverageTransactionValue } = require('../../src/utils/analytics');

describe('Analytics Functions', () => {
    describe('calculateTotalTransactions', () => {
        test('should return the total number of transactions', () => {
            const transactions = [
                { id: 1, value: 100 },
                { id: 2, value: 200 },
                { id: 3, value: 300 },
            ];
            const total = calculateTotalTransactions(transactions);
            expect(total).toBe(3);
        });

        test('should return 0 for an empty array', () => {
            const transactions = [];
            const total = calculateTotalTransactions(transactions);
            expect(total).toBe(0);
        });
    });

    describe('calculateAverageTransactionValue', () => {
        test('should return the average transaction value', () => {
            const transactions = [
                { id: 1, value: 100 },
                { id: 2, value: 200 },
                { id: 3, value: 300 },
            ];
            const average = calculateAverageTransactionValue(transactions);
            expect(average).toBe(200);
        });

        test('should return 0 for an empty array', () => {
            const transactions = [];
            const average = calculateAverageTransactionValue(transactions);
            expect(average).toBe(0);
        });
    });
});
