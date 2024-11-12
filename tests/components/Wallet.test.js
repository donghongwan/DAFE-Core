// tests/components/Wallet.test.js
import React from 'react';
import { render, screen } from '@testing-library/react';
import { WalletProvider } from '../context/WalletContext'; // Import the Wallet context provider
import Wallet from './Wallet';

describe('Wallet', () => {
    test('renders wallet balance', () => {
        render(
            <WalletProvider>
                <Wallet />
            </WalletProvider>
        );
        const balanceElement = screen.getByText(/balance/i); // Example text
        expect(balanceElement).toBeInTheDocument();
    });

    test('displays wallet address', () => {
        render(
            <WalletProvider>
                <Wallet />
            </WalletProvider>
        );
        const addressElement = screen.getByText(/your wallet address/i); // Example text
        expect(addressElement).toBeInTheDocument();
    });

    // Add more tests as needed to check for specific data or functionality
});
