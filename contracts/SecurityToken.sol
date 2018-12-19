pragma solidity ^0.4.25;

/// @title ERC777 ReferenceToken Contract
/// @author Jordi Baylina, Jacques Dafflon
/// @dev This token contract's goal is to give an example implementation
///  of ERC777 with ERC20 compatiblity using the base ERC777 and ERC20
///  implementations provided with the erc777 package.
///  This contract does not define any standard, but can be taken as a reference
///  implementation in case of any ambiguity into the standard


import { ERC777ERC20BaseToken } from "./ERC777ERC20BaseToken.sol";


contract SecurityToken is ERC777ERC20BaseToken {
    
    struct Document {
        string uri;
        bytes32 documentHash;
    }

    event ERC20Enabled();
    event ERC20Disabled();

    address public burnOperator;
    mapping (bytes32 => Document) private documents;

    /// @notice Security token creation
    /// @param _name The name of the token
    /// @param _symbol Abbreviation of the token
    /// @param _granularity Set the smallest part of the token that’s not divisible
    /// @param _defaultOperators Initial default operators
    /// @param _burnOperator Deprecated please use normal opeartor to burn tokens
    /// @param _initialSupply Initial amount of tokens upon creation 
    constructor(
        string _name,
        string _symbol,
        uint256 _granularity,
        address[] _defaultOperators,
        address _burnOperator,
        uint256 _initialSupply
    )
        public ERC777ERC20BaseToken(_name, _symbol, _granularity, _defaultOperators)
    {
        burnOperator = _burnOperator;
        doMint(msg.sender, _initialSupply, "");
    }

    /// @notice Disables the ERC20 interface. This function can only be called
    ///  by the owner.
    function disableERC20() public onlyOwner {
        mErc20compatible = false;
        setInterfaceImplementation("ERC20Token", 0x0);
        emit ERC20Disabled();
    }

    /// @notice Re enables the ERC20 interface. This function can only be called
    ///  by the owner.
    function enableERC20() public onlyOwner {
        mErc20compatible = true;
        setInterfaceImplementation("ERC20Token", this);
        emit ERC20Enabled();
    }
    
    /// @notice Get information about legal documentes related to this token
    /// @return Uri and hash of the document 
    function getDocument(bytes32 _name) external view returns (string, bytes32) {
        Document memory document = documents[_name];
        return (document.uri, document.documentHash);
    }
    
    /// @notice Put information about legal documentes related to this token 
    function setDocument(bytes32 _name, string _uri, bytes32 _documentHash) external onlyOwner {
        documents[_name] = Document(_uri, _documentHash);
    }
    
    /// @notice Deprecated
    function setBurnOperator(address _burnOperator) public onlyOwner {
        burnOperator = _burnOperator;
    }

    /* -- Mint And Burn Functions (not part of the ERC777 standard, only the Events/tokensReceived call are) -- */
    //
    /// @notice Generates `_amount` tokens to be assigned to `_tokenHolder`
    ///  Sample mint function to showcase the use of the `Minted` event and the logic to notify the recipient.
    /// @param _tokenHolder The address that will be assigned the new tokens
    /// @param _amount The quantity of tokens generated
    /// @param _operatorData Data that will be passed to the recipient as a first transfer
    function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public onlyOwner {
        doMint(_tokenHolder, _amount, _operatorData);
    }

    /// @notice Burns `_amount` tokens from `msg.sender`
    ///  Silly example of overriding the `burn` function to only let the owner burn its tokens.
    ///  Do not forget to override the `burn` function in your token contract if you want to prevent users from
    ///  burning their tokens.
    /// @param _amount The quantity of tokens to burn
    function burn(uint256 _amount, bytes _data) public onlyOwner {
        super.burn(_amount, _data);
    }

    /// @notice Burns `_amount` tokens from `_tokenHolder` by `_operator`
    ///  Silly example of overriding the `operatorBurn` function to only let a specific operator burn tokens.
    ///  Do not forget to override the `operatorBurn` function in your token contract if you want to prevent users from
    ///  burning their tokens.
    /// @param _tokenHolder The address that will lose the tokens
    /// @param _amount The quantity of tokens to burn
    /*function operatorBurn(address _tokenHolder, uint256 _amount, bytes _data, bytes _operatorData) public {
        require(msg.sender == burnOperator, "Not a burn operator");
        super.operatorBurn(_tokenHolder, _amount, _data, _operatorData);
    }*/

    function doMint(address _tokenHolder, uint256 _amount, bytes _operatorData) private {
        requireMultiple(_amount);
        mTotalSupply = mTotalSupply.add(_amount);
        mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);

        callRecipient(msg.sender, 0x0, _tokenHolder, _amount, "", _operatorData, true);

        addWhitelistAddress(_tokenHolder);
        emit Minted(msg.sender, _tokenHolder, _amount, _operatorData);
        if (mErc20compatible) { emit Transfer(0x0, _tokenHolder, _amount); }
    }
}