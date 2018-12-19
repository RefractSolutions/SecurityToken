pragma solidity ^0.4.25;


interface ERC777TokensRecipient {
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes data,
        bytes operatorData
    ) public;
}