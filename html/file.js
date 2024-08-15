import { eth, Web3 } from "web3";


// HTML Elements
let addressArray = document.getElementById("addresses")




//Being in the testing environment, we'll be using Anvil
let anvil = true;
let provider = anvil
  ? new Web3.providers.HttpProvider("http://127.0.0.1:8545")
  : new Web3.providers.HttpProvider(window.ethereum) ||
    new Web3.givenProvider();

let addresses
let wallet
// creating a WEB 3 JS instance for interacting with blockchain
let web3 = new Web3(provider)

const main = async () => {
 wallet = web3.wallet.create()
 addresses = await web3.eth.getAccounts()
 addressArray.innerHTML = addresses
 
}

main()


//adding address to the wallet



//first :- with the help of getAccounts get all of the accounts printed onto the screen
//second :- when a user clicks onto that account select it as the default account that will be used for signing the transactions