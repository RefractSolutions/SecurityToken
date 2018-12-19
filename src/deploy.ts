import Web3 from 'web3'
import EthereumTx from 'ethereumjs-tx'
import * as env from 'dotenv'
import * as contractData from './contracts/SecurityToken.json'

env.config()

const setTokenTx = (nonce: number,data: string) => 
        ({
            nonce,
            from: process.env.DEPLOYER_ADDRESS,
            to: undefined,
            value: '0x00',
            data
        })

    const sendTx = async () => {
            const web3 = new Web3(new Web3.providers.HttpProvider(process.env.WEB3_PROVIDER!))
            const eth = web3.eth
            
            const contract = new eth.Contract(contractData.abi)
            
            const transaction = setTokenTx(
                await eth.getTransactionCount(process.env.DEPLOYER_ADDRESS!),
                '0x' + contract.deploy({
                    data: contractData.object,
                    arguments: [
                        'Test Security Token', // the name of the token
                        'TST', // abbriveation  of token
                        1, // just use 1 
                        [], // default operators
                        process.env.DEPLOYER_ADDRESS!,
                        web3.utils.toWei('1000000', 'ether') // the issuing quantity of tokens
                    ]
                }).encodeABI()
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


async function deploy() {
    console.info('Deploy contract...')
    console.info(await sendTx())
}

deploy()