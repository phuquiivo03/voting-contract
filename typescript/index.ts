import { Account, Aptos, AptosConfig, CommittedTransactionResponse, Network } from "@aptos-labs/ts-sdk";
import { InputViewFunctionData } from "@aptos-labs/ts-sdk";
import { InputTransactionData } from "@aptos-labs/wallet-adapter-react";

interface IAccountResponse {
    name: string,
    score: number,
    user_address: string
}

const PACKAGE='0x3364559e000a43e121514b2d19ab16952290fa58356cea5bb5db4c163885df71'
 // Setup the client
const config = new AptosConfig({ network: Network.TESTNET });
const aptos = new Aptos(config);

import axios from "axios";

async function callGraphqlApi(query: string, variables: any) {
  try {
    const response = await axios.post('', {
      query,
      variables,
    });
    return response.data;
  } catch (error) {
    console.error("Failed to call GraphQL API:", error);
    throw error;
  }
}

 async function init_account() {
    console.log("init account...")
    const signerAccount: Account = Account.generate();
    // Fund the account on chain. Funding an account creates it on-chain.
    await aptos.fundAccount({
    accountAddress: signerAccount.accountAddress,
    amount: 100000000,
    });
    console.log("done init")
    return signerAccount
 }


async function create_vote_session(
  signAndExcute: (transaction: InputTransactionData) => Promise<any>, 
  voteSessionName: string,
  onSuccess: () => void,
  onFalure: () => void,
  

) {
    //build transaction ================================================================= đá
    const transaction:InputTransactionData = {
      data: {
        function:`${PACKAGE}::user::create_vote_session`,
        functionArguments:[voteSessionName]
      }
    }
      try {
        const response = await signAndExcute(transaction);
    // wait for transaction
        await aptos.waitForTransaction({transactionHash:response.hash});
        onSuccess()
      } catch(e) {
        onFalure()
      }
}

async function vote(
  signAndExcute: (transaction: InputTransactionData) => Promise<any>, 
  onSuccess: () => void,
  onFalure: () => void
) {
  console.log("Hello from vote function")
  let transaction: InputTransactionData = {
    data: {
      function: `${PACKAGE}::user::vote`,
      functionArguments: [],
    },
  };
  
  
  try {
    const response = await signAndExcute(transaction);
    // wait for transaction
      await aptos.waitForTransaction({transactionHash:response.hash});
      onSuccess()
  } catch(e) {
    onFalure()
  }
  

}

async function get_vote_session_info(
  signer: Account, 
  onSuccess: (acount: IAccountResponse)=> void,
  onFalure: ()=> void

) {
  const payload: InputViewFunctionData = {
    function: `${PACKAGE}::user::get_account_info`,
    functionArguments: [signer.accountAddress],
  };

  const chainId = (await aptos.view({ payload }))[0]; //get the result from the chain
  let json_result = JSON.parse(JSON.stringify(chainId))?.vec[0] //parse the result to json
  console.log("view info")
  if(json_result) { //check weather result is defined or not
    onSuccess({name: json_result?.name,
      score: json_result?.score,
      user_address: json_result?.user_address})
  } else {
    onFalure()
  }
}
 
export {create_vote_session, get_user_info, init_account, vote, submit_request, type IAccountResponse};


// interacted with the contract
// keep implementing the contract
