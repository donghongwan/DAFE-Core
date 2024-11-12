// tests/components/Dashboard.test.js
import React from 'react';
import { render, screen } from '@testing-library/react';
import Dashboard from './Dashboard';

describe('Dashboard', () => {
    test('renders dashboard title', () => {
        render(<Dashboard />);
        const titleElement = screen.getByText(/dashboard/i);
        expect(titleElement).toBeInTheDocument();
    });

    test('displays analytics data', () => {
        render(<Dashboard />);
        const analyticsElement = screen.getByText(/total transactions/i); // Example text
        expect(analyticsElement).toBeInTheDocument();
    });

    // Add more tests as needed to check for specific data or functionality
});
