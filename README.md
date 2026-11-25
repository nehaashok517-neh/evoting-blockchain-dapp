# E-Voting Blockchain DApp 🗳️

A decentralized, transparent, and tamper-proof electronic voting application built on Ethereum using **Hardhat**, **Solidity 0.8.20**, **Ethers.js v6**, and **Tailwind CSS**.

## Features

- **Smart Contract (`EVoting.sol`)**:
  - Role-based permissions (Election Admin / Official vs Voters).
  - State machine lifecycle: `NotStarted` ➡️ `Ongoing` ➡️ `Ended`.
  - Candidate registration and voter authorization.
  - One-person, one-vote enforcement on-chain.
  - Instant transparent tally and winner determination.
- **Frontend DApp (`index.html`)**:
  - Connects directly to local Hardhat node (`http://127.0.0.1:8545`) via `ethers.JsonRpcProvider`.
  - Includes a dropdown to switch between Hardhat local accounts (`Account #0` to `Account #5`) with instant local transaction signing.
  - Full admin and voter control dashboard (Add Candidate, Register Voter, Start/End Election, Vote).
  - Optional MetaMask wallet support.

## Project Structure

```
ca3-evoting/
├── contracts/
│   └── EVoting.sol          # Solidity smart contract
├── frontend/
│   └── index.html           # DApp web interface (Tailwind CSS + Ethers.js)
├── scripts/
│   └── deploy.js            # Deployment script for local node
├── hardhat.config.js        # Hardhat configuration (Solidity 0.8.20, local network)
├── package.json             # Project dependencies (CommonJS)
└── README.md
```

## Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Start Local Hardhat Node
```bash
npx hardhat node
```
This spins up a local Ethereum JSON-RPC node on `http://127.0.0.1:8545` with chain ID `31337` and 20 pre-funded test accounts.

### 3. Deploy the Smart Contract
In a separate terminal, deploy `EVoting.sol` to your running local node:
```bash
npx hardhat run scripts/deploy.js --network localhost
```
Note the deployed contract address (typically `0x5FbDB2315678afecb367f032d93F642f64180aa3`).

### 4. Open the Frontend
Open `frontend/index.html` in your web browser:
1. Ensure the contract address matches your deployed contract address and click **Load Contract**.
2. As **Account #0** (Admin):
   - Add at least 2 candidates.
   - Register voter accounts (e.g., click quick-fill `Acc#1`, `Acc#2` and click **Register**).
   - Click **Start Election**.
3. Switch the **Account** dropdown to **Account #1** or **Account #2** to cast votes.
4. Switch back to **Account #0** and click **End Election** to finalize results and declare the winner!
