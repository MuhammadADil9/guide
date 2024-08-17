import { eth, Web3 } from "web3";

// HTML Elements
let addressArray = document.getElementById("addresses");
let selectedAddr = document.getElementById("selectedAddress")



//Being in the testing environment, we'll be using Anvil
let anvil = true;
let provider = anvil
  ? new Web3.providers.HttpProvider("http://127.0.0.1:8545")
  : new Web3.providers.HttpProvider(window.ethereum) ||
    new Web3.givenProvider();

let addresses; /* Instance for importing the  addresses from blockchain */
let wallet; /* Instance for wallet */
let web3 = new Web3(provider); /* instance of class WEB 3*/
let selectedAddress;

//appending the addresses to drop down list done
//when selected it should be selected as default done
//deploying the contract
//listening to events and logs

const main = async () => {
  wallet = web3.wallet.create();
  addresses = await web3.eth.getAccounts();

  addresses.slice(0, 5).forEach((val, index) => {
    let child = document.createElement("option");
    child.setAttribute("id", index);
    child.innerHTML = val;
    addressArray.addEventListener("change", appendValue);
    addressArray.appendChild(child);
  });

  function appendValue() {
    selectedAddress = addressArray.value;
    selectedAddr.innerText = selectedAddress
    web3.eth.defaultAccount = selectedAddress;
    console.log("Selected Account :- ", web3.eth.defaultAccount);
    console.log("-------------------");
  }

  
};

main();

//adding address to the wallet

//first :- with the help of getAccounts get all of the accounts printed onto the screen
//second :- when a user clicks onto that account select it as the default account that will be used for signing the transactions
