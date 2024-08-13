import { Web3 } from "web3";



const connect = async () => {
    let web3 = new Web3.providers(Web3.givenProvider)
    console.log(web3)
    console.log("connected")
}



window.connect = connect