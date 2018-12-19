pragma solidity ^0.4.25;

import "./Ownable.sol";

contract Transferable is Ownable {
    
    mapping(address => bool) private banned;
    
    modifier isTransferable() {
        require(!banned[msg.sender], "Account is frozen");
        _;
    }
    
    function freezeAccount(address account) public onlyOwner {
        banned[account] = true;
    }   
    
    function unfreezeAccount(address account) public onlyOwner {
        banned[account] = false;
    }

    function isAccountFrozen(address account) public view returns(bool) {
        return banned[account];
    }
    
} 