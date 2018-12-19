pragma solidity ^0.4.25;

import "./Pausable.sol";
import "./Transferable.sol";

    contract Depositable is Pausable, Transferable {

        mapping(address => bool) public isDepositOperator;
        mapping(address => bool) public isDepositAddress;
        
        
        constructor() internal {
        isDepositOperator[msg.sender] = true;
        }
        
        
        modifier depositOperator() {
            require(isDepositOperator[msg.sender], "Not allow. Not an deposit operator.");
            _;
        }
        
        function addDepositOperator(address _address)
            public
            onlyOwner
        {
            require(!isDepositOperator[_address], "Operator already added");
            isDepositOperator[_address] = true;
        }
        
        function removeDepositOperator(address _address)
            public
            onlyOwner
        {
            require(isDepositOperator[_address], "Operator is not added");
            isDepositOperator[_address] = false;
        }
        
        function addDepositAddresses(address[] _addresses)
            public
            depositOperator
        {
            for (uint i = 0; i < _addresses.length; i++) {
                if(!isDepositAddress[_addresses[i]]) {
                    isDepositAddress[_addresses[i]] = true;
                }
            }
        }
        

        function forceRemoveDepositAddress(address _address)
            public
            onlyOwner
        {
            isDepositAddress[_address] = false;
        }
        
    }