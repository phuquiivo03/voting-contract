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
# Functions
1. create_vote_session:
***Description***: This function will create a vote session including
id, 
description, 
owner, 
votes, 
is_active, 
submited_votes
***Args***: name: String
     
2. vote
***Description***: this function is voting on a vote session by vote session id, each wallet address just vote once
***Arguments***: vote_session_id: u64
5. close_vote_session
   ***Description***: This function is close a vote session, switch is_active to false, just owner of voting session can do this action
   ***Arguments***: vote_session_id: u64
# 📑 Lisence
