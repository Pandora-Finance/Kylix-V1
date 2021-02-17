pragma solidity ^0.5.15;

import "./SmartWallet.sol";

interface IERC20{
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function transfer(address _to, uint256 _value) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

/// @title LogicRegistry
/// @notice
/// @dev LogicRegistry
contract LogicRegistry {
    event LogEnableLogic(address logicAddress);
    event LogDisableLogic(address logicAddress);

    /// @notice Map of logic proxy state
    mapping(address => bool) public logicProxies;
    address public admin;

    /// @dev
    /// @param _logicAddress (address)
    /// @return  (bool)
    function logic(address _logicAddress) public view returns (bool) {
        return logicProxies[_logicAddress];
    }

    /// @dev Enable logic proxy address
    /// @param _logicAddress (address)
    function enableLogic(address _logicAddress) public  {
        require(msg.sender == admin, "Not Admin");
        logicProxies[_logicAddress] = true;
        emit LogEnableLogic(_logicAddress);
    }

    /// @dev Disable logic proxy address
    /// @param _logicAddress (address)
    function disableLogic(address _logicAddress) public  {
        require(msg.sender == admin, "Not Admin");
        logicProxies[_logicAddress] = false;
        emit LogDisableLogic(_logicAddress);
    }

}

/**
 * @dev Deploys a new proxy instance and sets msg.sender as owner of proxy
 */
contract WalletRegistry is LogicRegistry {
    event Created(address indexed owner, address proxy);
    event LogRecord(
        address indexed currentOwner,
        address indexed nextOwner,
        address proxy
    );

    /// @notice Address to UserWallet proxy map
    mapping(address => SmartWallet) public wallets;
    uint public users;
    /// @dev Deploys a new proxy instance and sets custom owner of proxy
    /// Throws if the owner already have a UserWallet
    /// @return proxy ()
    function deployWallet(address user) public returns (SmartWallet wallet) {
        require(
            wallets[user] == SmartWallet(0),
            "multiple-proxy-per-user-not-allowed"
        );
        wallet = new SmartWallet(user);
        wallets[user] = wallet; // will be changed via record() in next line execution
        users++;
        emit Created(user, address(wallet));
    }

}

/// @dev Initializing Registry
contract Registry is WalletRegistry {
    constructor() public {
        admin = msg.sender;
    }
}
