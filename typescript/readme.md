# Network: Testnet
# Setup wallet support

[Aptos wallet connect](https://aptos.dev/en/build/guides/build-e2e-dapp/3-add-wallet-support)

Use `const {signAndSubmitTransaction} = useWallet()`   use this wallet to sign transactions

# API docs for calling contract

## .env 
```REACT_APP_PACKAGE_ADDRESS=0x3364559e000a43e121514b2d19ab16952290fa58356cea5bb5db4c163885df71```
## Type:




## Functions:

### Create vote:
```
async function create_vote_session(
  signAndExcute: (transaction: InputTransactionData) => Promise<any>, 
  voteSessionName: string,
  onSuccess: () => void,
  onFalure: () => void,
)

```

#### Description:

This function will create a vote session

#### Parameter:

1. signAndExcute: this is signAndSubmitTransaction get from useWallet use to sign transaction
2. onSuccess: ()=> void: This function will be called if create successful
3. onFalure: ()=> This function will be called when get get user info failed (network error) .

### Vote:
```
async function vote(
  signAndExcute: (transaction: InputTransactionData) => Promise<any>, 
  id: number,
  onSuccess: () => void,
  onFalure: () => void
)
```

#### Description:

This function using for voting action, each user just vote once.

#### Parameters:

1. signAndExcute: this is signAndSubmitTransaction get from useWallet use to sign transaction
2. id: vote session id
3. onSuccess: ()=> void: This function will be called if vote successful
4.  onFalure: ()=> This function will be called when vote fail (vote session not found or this user already vote to this session).

### Close vote session
```
async function close_vote_session(
  signAndExcute: (transaction: InputTransactionData) => Promise<any>, 
  voteSessionId: number,
  onSuccess: () => void,
  onFalure: () => void,
) 
```
#### Description
This function will close a vote session, user will not able to vote to this session.

#### Parameters:

1. signAndExcute: this is signAndSubmitTransaction get from useWallet use to sign transaction
2. id: vote session id
3. onSuccess: ()=> void: This function will be called if close successful
4.  onFalure: ()=> This function will be called when vote fail (user is not owner of this session).

### Get vote session info
```
async function get_vote_session_info(
  id: number, 
  onSuccess: (result: any)=> void,
  onFalure: ()=> void

)
```

#### Description
This function will get a session info by id. 

#### Parameters
1. id: vote session id
2. onSuccess: ()=> void: This function will be called if get successful
3.  onFalure: ()=> This function will be called when get fail (session not found).

### Get all vote sessions
```
async function get_all_vote_sessions(
onSuccess: (result: Array<any>)=> void,
onFalure: ()=> void)
```

#### Description
This function will get a session info by id. 

#### Parameters
1. id: vote session id
2. onSuccess: (result: Array<any>)=> void: This function will be called if get successful

