pragma solidity ^0.4.25;

import "./Depositable.sol";


contract Whitelist is Depositable {
    uint8 public constant version = 1;

    mapping (address => bool) private whitelistedMap;
    bool public isWhiteListDisabled;
    
    address[] private addedAdresses;
    address[] private removedAdresses;

    event Whitelisted(address indexed account, bool isWhitelisted);

    function whitelisted(address _address)
        public
        view
        returns(bool)
    {
        if (paused()) {
            return false;
        } else if(isWhiteListDisabled) {
            return true;
        }

        return whitelistedMap[_address];
    }

    function addAddress(address _address)
        public
        onlyOwner
    {
        require(whitelistedMap[_address] != true, "Account already whitelisted");
        addWhitelistAddress(_address);
        emit Whitelisted(_address, true);
    }

    function removeAddress(address _address)
        public
        onlyOwner
    {
        require(whitelistedMap[_address] != false, "Account not in the whitelist");
        removeWhitelistAddress(_address);
        emit Whitelisted(_address, false);
    }
    
    function addedWhiteListAddressesLog() public view returns (address[]) {
        return addedAdresses;
    }
    
    function removedWhiteListAddressesLog() public view returns (address[]) {
        return removedAdresses;
    }
    
    function addWhitelistAddress(address _address) internal {
        if(whitelistedMap[_address] == false)
            addedAdresses.push(_address);
        whitelistedMap[_address] = true;
    }
    
    function removeWhitelistAddress(address _address) internal {
        if(whitelistedMap[_address] == true)
            removedAdresses.push(_address);
        whitelistedMap[_address] = false;
    }

    function enableWhitelist() public onlyOwner {
        isWhiteListDisabled = false;
    }

    function disableWhitelist() public onlyOwner {
        isWhiteListDisabled = true;
    }
  
}
