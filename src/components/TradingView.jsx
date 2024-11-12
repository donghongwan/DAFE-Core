// src/components/TradingView.jsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

const TradingView = () => {
    const [options, setOptions] = useState([]);
    const [futures, setFutures] = useState([]);
    const [strikePrice, setStrikePrice] = useState('');
    const [expiration, setExpiration] = useState('');

    useEffect(() => {
        const fetchOptions = async () => {
            try {
                const response = await axios.get('/api/options'); // Replace with your API endpoint
                setOptions(response.data);
            } catch (error) {
                console.error("Error fetching options:", error);
            }
        };

        const fetchFutures = async () => {
            try {
                const response = await axios.get('/api/futures'); // Replace with your API endpoint
                setFutures(response.data);
            } catch (error) {
                console.error("Error fetching futures:", error);
            }
        };

        fetchOptions();
        fetchFutures();
    }, []);

    const handleCreateOption = async () => {
        try {
            await axios.post('/api/options/create', { strikePrice, expiration }); // Replace with your API endpoint
            alert('Option created successfully!');
            setStrikePrice('');
            setExpiration('');
            // Optionally refresh options list
        } catch (error) {
            console.error("Error creating option:", error);
            alert('Failed to create option!');
        }
    };

    return (
        <div className="trading-view">
            <h1>Trading View</h1>
            <h2>Options</h2>
            <div>
                <input
                    type="number"
                    placeholder="Strike Price"
                    value={strikePrice}
                    onChange={(e) => setStrikePrice(e.target.value)}
                />
                <input
                    type="datetime-local"
                    placeholder="Expiration"
                    value={expiration}
                    onChange={(e) => setExpiration(e.target.value)}
                />
                <button onClick={handleCreateOption}>Create Option</button>
            </div>
            <h2>Available Options</h2>
            <ul>
                {options.map((option, index) => (
                    <li key={index}>
                        Option ID: {option.id}, Strike Price: {option.strikePrice}, Expiration: {new Date(option.expiration).toLocaleString()}
                    </li>
                ))}
            </ul>
            <h2>Futures</h2>
            <ul>
                {futures.map((future, index) => (
                    <li key={index}>
                        Future ID: {future.id}, Price: {future.price}, Expiration: {new Date(future.expiration).toLocaleString()}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default TradingView;
