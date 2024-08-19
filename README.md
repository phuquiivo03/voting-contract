# About this repository
📘 This project is building smartcontract for mamaging account for aptopus products

# 🚀 Objective

# Function

# Get Started
1. Clone this repo:
```bash
git clone https://github.com/Weminal-labs/Aptous-smart-contract.git
```
2. Init an aptos account (aptopus in example)
```bash
aptos init --profile profilename
```
3. Faucet (devnet or testnet)
```bash
aptos account fund-with-faucet --account profilename --faucet-url https://faucet.devnet.aptoslabs.com --url https://fullnode.devnet.aptoslabs.com
```
4. Compile smartcontract
```bash
aptos move compile --named-addresses aptopus=profilename
```
5. Publish the contract
```bash
aptos move publish --included-artifacts none --named-addresses aptopus=profilename --profile=profilename
```
# 📑 Lisence
This project is owned by Weminal lab
