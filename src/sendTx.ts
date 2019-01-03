export const setTokenTx = (nonce: number,data: string, to?: string) => 
        ({
            nonce,
            from: process.env.DEPLOYER_ADDRESS,
            to,
            value: '0x00',
            data
        })