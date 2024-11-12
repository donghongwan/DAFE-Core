// src/hooks/useWallet.js
import { useEffect, useState } from 'react';
import axios from 'axios';

const useWallet = () => {
    const [balance, setBalance] = useState(0);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchBalance = async () => {
            try {
                const response = await axios.get('/api/wallet/balance'); // Replace with your API endpoint
                setBalance(response.data.balance);
            } catch (err) {
                setError(err);
                console.error("Error fetching balance:", err);
            } finally {
                setLoading(false);
            }
        };

        fetchBalance();
    }, []);

    const sendTransaction = async (recipient, amount) => {
        try {
            setLoading(true);
            await axios.post('/api/wallet/send', { recipient, amount }); // Replace with your API endpoint
            alert('Transaction successful!');
            // Optionally refresh balance
            await fetchBalance();
        } catch (err) {
            setError(err);
            console.error("Error sending transaction:", err);
            alert('Transaction failed!');
        } finally {
            setLoading(false);
        }
    };

    return { balance, loading, error, sendTransaction };
};

export default useWallet;
