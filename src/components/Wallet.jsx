// src/components/Wallet.jsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Wallet = () => {
    const [balance, setBalance] = useState(0);
    const [recipient, setRecipient] = useState('');
    const [amount, setAmount] = useState('');

    useEffect(() => {
        const fetchBalance = async () => {
            try {
                const response = await axios.get('/api/wallet/balance'); // Replace with your API endpoint
                setBalance(response.data.balance);
            } catch (error) {
                console.error("Error fetching balance:", error);
            }
        };

        fetchBalance();
    }, []);

    const handleSend = async () => {
        try {
            await axios.post('/api/wallet/send', { recipient, amount }); // Replace with your API endpoint
            alert('Transaction successful!');
            setRecipient('');
            setAmount('');
            // Optionally refresh balance
        } catch (error) {
            console.error("Error sending transaction:", error);
            alert('Transaction failed!');
        }
    };

    return (
        <div className="wallet">
            <h1>Wallet</h1>
            <h2>Balance: {balance} ETH</h2>
            <div>
                <input
                    type="text"
                    placeholder="Recipient Address"
                    value={recipient}
                    onChange={(e) => setRecipient(e.target.value)}
                />
                <input
                    type="number"
                    placeholder="Amount"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                />
                <button onClick={handleSend}>Send</button>
            </div>
        </div>
    );
};

export default Wallet;
