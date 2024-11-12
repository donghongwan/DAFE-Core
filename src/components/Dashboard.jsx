// src/components/Dashboard.jsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Dashboard = () => {
    const [analyticsData, setAnalyticsData] = useState(null);

    useEffect(() => {
        const fetchAnalyticsData = async () => {
            try {
                const response = await axios.get('/api/analytics'); // Replace with your API endpoint
                setAnalyticsData(response.data);
            } catch (error) {
                console.error("Error fetching analytics data:", error);
            }
        };

        fetchAnalyticsData();
    }, []);

    if (!analyticsData) {
        return <div>Loading...</div>;
    }

    return (
        <div className="dashboard">
            <h1>Analytics Dashboard</h1>
            <div className="analytics-metrics">
                <div>
                    <h2>Total Transactions</h2>
                    <p>{analyticsData.totalTransactions}</p>
                </div>
                <div>
                    <h2>Total Users</h2>
                    <p>{analyticsData.totalUsers}</p>
                </div>
                <div>
                    <h2>Transaction Volume</h2>
                    <p>{analyticsData.transactionVolume}</p>
                </div>
            </div>
        </div>
    );
};

export default Dashboard;
