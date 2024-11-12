// src/App.js
import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { AnalyticsProvider } from './context/AnalyticsContext'; // Example context for analytics
import { WalletProvider } from './context/WalletContext'; // Example context for wallet management
import Dashboard from './components/Dashboard';
import Wallet from './components/Wallet';
import TradingView from './components/TradingView';
import NotFound from './components/NotFound'; // A component for handling 404 errors
import './App.css'; // Import your CSS styles

const App = () => {
    return (
        <Router>
            <AnalyticsProvider>
                <WalletProvider>
                    <div className="app">
                        <header>
                            <h1>My DeFi App</h1>
                            {/* You can add a navigation bar here */}
                        </header>
                        <main>
                            <Switch>
                                <Route path="/" exact component={Dashboard} />
                                <Route path="/wallet" component={Wallet} />
                                <Route path="/trading" component={TradingView} />
                                <Route component={NotFound} /> {/* Fallback for 404 */}
                            </Switch>
                        </main>
                        <footer>
                            <p>&copy; {new Date().getFullYear()} My DeFi App</p>
                        </footer>
                    </div>
                </WalletProvider>
            </AnalyticsProvider>
        </Router>
    );
};

export default App;
