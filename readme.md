# Katalyse Security Token

## Abstract

This standard defines a new way to interact with a token contract while remaining backward compatible with ERC20.

It defines advanced features to interact with tokens. Namely, operators to send tokens on behalf of another address—contract or regular account—and send/receive hooks to offer  more secure control over tokens by regulating entities.

It takes advantage of ERC820 to find out whether and where to notify contracts and regular addresses when they receive tokens as well as to allow compatibility with already-deployed contracts.

Also it provides features likle whitelist where token holders limited to spend their tokens and freezing addreess support.

In addtion it provides documentation refernce of regulation


## Motivation

This standard tries to improve the widely used ERC20 and ERC777 tokens standard. The main advantages of this standard are:

1. Suitable for goverment regulation and related institutions 
2. More powerful control
3. Transparency
4. Compatability with ERC20 and ERC777
5. Flexability to use for exchanges and escrow but prevent abuse

## Sending Tokens

* Send addresses optionally could be whitelisted to prevent non regulating activities
* Regulating operator can be assigned to ech token holder to send and burn tokens
* Any token holder address can be frozen to send by token contract owner

## Mint tokens

* Tokens must be mint by contract owner before to use it

## Burn tokens

* Tokens can be burned by assigned operator which is authorized by token contract owner

## Deposit only addresses

* A seperate whitelist is maintained specifically for deposit only addresses. Most cryptocurrency exchanges currently generate a unique specific eth address for each user to deposit their tokens. 
* Deposit only addresses can only be added by exchange operators
* Deposit addresses can only send tokens to whitelisted addresses by the issuer. They cannot send to another deposit address.

## More Information

[Please see ERC777 standard](https://eips.ethereum.org/EIPS/eip-777)

[Also plese see contract functions API](https://pinnacleone.github.io/docs/SecurityToken/)
