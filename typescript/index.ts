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


async function close_vote_session(
  signAndExcute: (transaction: InputTransactionData) => Promise<any>, 
  voteSessionId: number,
  onSuccess: () => void,
  onFalure: () => void,

) {
    //build transaction ================================================================= đá
    const transaction:InputTransactionData = {
      data: {
        function:`${PACKAGE}::user::close_vote_session`,
        functionArguments:[voteSessionId]
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
  id: number,
  onSuccess: () => void,
  onFalure: () => void
) {
  console.log("Hello from vote function")
  let transaction: InputTransactionData = {
    data: {
      function: `${PACKAGE}::user::vote`,
      functionArguments: [id],
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

async function get_all_vote_sessions(
onSuccess: (result: Array<any>)=> void,
onFalure: ()=> void) {

const payload: InputViewFunctionData = {
  function: `${PACKAGE}::user::get_all_vote_session`,
  functionArguments: [],
};

const chainId = (await aptos.view({ payload })); //get the result from the chain
let json_result = JSON.parse(JSON.stringify(chainId)) //parse the result to json
if(json_result) { //check weather result is defined or not
  onSuccess(json_result)
} else {
  onFalure()
}
}

async function get_vote_session_info(
  id: number, 
  onSuccess: (result: any)=> void,
  onFalure: ()=> void

) {
  const payload: InputViewFunctionData = {
    function: `${PACKAGE}::user::get_VoteSession_info`,
    functionArguments: [id],
  };
  try {
    
    const chainId = (await aptos.view({ payload }))[0]; //get the result from the chain
    let json_result = JSON.parse(JSON.stringify(chainId))?.vec[0] //parse the result to json
    onSuccess(json_result)
  }catch {
    
    onFalure()
  }
  
}
 
export {create_vote_session,get_all_vote_sessions, close_vote_session, get_vote_session_info, vote, type IAccountResponse};


// interacted with the contract
// keep implementing the contract
