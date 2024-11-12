# API Documentation

## Introduction
The DAFE-Core API provides endpoints for interacting with the ecosystem's smart contracts and retrieving data.

## Endpoints
### 1. Get Token Balance
- **Endpoint**: `/api/token/balance`
- **Method**: GET
- **Parameters**: 
  - `address`: The wallet address to check the balance.
- **Response**: 
  - `balance`: The token balance of the specified address.

### 2. Submit Proposal
- **Endpoint**: `/api/governance/proposal`
- **Method**: POST
- **Body**: 
  ```json
  {
    "title": "Proposal Title",
    "description": "Proposal Description"
  }
