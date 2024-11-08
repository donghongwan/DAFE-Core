# DAFE Setup Guide

## Prerequisites
- Node.js (version X.X.X)
- npm (version X.X.X)
- Truffle (or Hardhat) for smart contract development
- A local Ethereum node (e.g., Ganache) or access to a testnet (e.g., Rinkeby)

## Installation Steps
1. **Clone the Repository**
   ```bash
   1 git clone https://github.com/KOSASIH/DAFE-Core.git
   2 cd DAFE-Core
   ```

2. **Install Dependencies**

   ```bash
   1 npm install
   ```

3. **Set Up Environment Variables** Create a .env file in the root directory and add the necessary environment variables (e.g., private keys, API keys).

4. **Deploy Smart Contracts**

   ```bash
   1 truffle migrate --network development
   ```

5. **Run the Application**

   ```bash
   1 npm start
   ```
   
# Conclusion
Follow these steps to set up the DAFE environment on your local machine. For any issues, refer to the troubleshooting section or seek help from the community.
