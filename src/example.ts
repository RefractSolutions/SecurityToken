import Web3 from 'web3'
import EthereumTx from 'ethereumjs-tx'
import * as contractData from './contracts/SecurityToken.json'
import { setTokenTx } from './sendTx'
import * as env from 'dotenv'

env.config()

const sendTx = async () => {
    const web3 = new Web3(new Web3.providers.HttpProvider(process.env.WEB3_PROVIDER!))
 
    const eth = web3.eth
    
    const contract = new eth.Contract(contractData.abi, process.env.CONTRACT_ADDRESS)
    
    const transaction = setTokenTx(
        await eth.getTransactionCount(process.env.DEPLOYER_ADDRESS!),
        contract.methods.addDepositAddresses(['0xb31c4de11ecd2a79c50e5afaab12f6c55d5fd3f8']).encodeABI(),
        process.env.CONTRACT_ADDRESS
    )

    const tx = new EthereumTx({
        ...transaction,
        gasPrice: web3.utils.toHex(await eth.getGasPrice()),
        gasLimit: web3.utils.toHex(await eth.estimateGas(transaction))
    })

    tx.sign(Buffer.from(process.env.DEPLOYER_PK!, 'hex'))
    const data = '0x' + tx.serialize().toString('hex')
    return await eth.sendSignedTransaction(data).on('transactionHash', txid => {
        console.info('Transaction has been submitted', txid)
    })
}


async function execute() {
    console.info('Executing method addDepositAddresses(...)')
    console.info(await sendTx())
}

execute()