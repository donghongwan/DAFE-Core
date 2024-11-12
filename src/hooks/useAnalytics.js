// src/hooks/useAnalytics.js
import { useEffect, useState } from 'react';
import axios from 'axios';

const useAnalytics = () => {
    const [analyticsData, setAnalyticsData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchAnalyticsData = async () => {
            try {
                const response = await axios.get('/api/analytics'); // Replace with your API endpoint
                setAnalyticsData(response.data);
            } catch (err) {
                setError(err);
                console.error("Error fetching analytics data:", err);
            } finally {
                setLoading(false);
            }
        };

        fetchAnalyticsData();
    }, []);

    return { analyticsData, loading, error };
};

export default useAnalytics;
