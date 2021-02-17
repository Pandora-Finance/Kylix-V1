pragma solidity ^0.5.15;
pragma experimental ABIEncoderV2;

interface IRegistry {
    function isAuthorised(address sender) external view returns (bool);

    function logic(address logicAddr) external view returns (bool);

    function notAllowed(address erc20) external view returns (bool);

    function deployWallet() external returns (address);

    function wallets(address user) external view returns (address);

    function forwardProxy() external view returns(address);
}

contract AddressRecord {
    address public registry;
    modifier logicAuth(address logicAddr) {
        require(logicAddr != address(0), "logic-proxy-address-required");
        require(
            IRegistry(registry).logic(logicAddr),
            "logic-not-authorised"
        );
        _;
    }
}

contract UserAuth is AddressRecord {
    // event LogSetOwner(address indexed owner);
    address public owner;
    uint public nonce;
    /**
     * @dev Throws if not called by owner or contract itself
     */
    modifier auth {
         require(IRegistry(registry).isAuthorised(msg.sender),"permission deied");
        _;
    }
      function isAuthorised() public view returns (bool){
      return IRegistry(registry).isAuthorised(msg.sender);
    }
  }

/**
 * @title User Owned Contract Wallet
 */
contract SmartWallet is UserAuth {

    constructor(address user) public {
        registry = msg.sender;
        owner = user;
    }

    function() external payable {}

    function execute(address _target, bytes memory _data)
        public
        payable
        // logicAuth(_target)
    {
        require(_target != address(0), "target-invalid");
        assembly {
            let succeeded := delegatecall(
                sub(gas, 5000),
                _target,
                add(_data, 0x20),
                mload(_data),
                0,
                32
            )
            switch iszero(succeeded)
                case 1 {
                    revert(0, 0)
                }
        }
    }

    function executeMany(address[] memory targets, bytes[] memory datas)
        public
        payable
    {
        for (uint256 i = 0; i < targets.length; i++) {
            execute(targets[i], datas[i]);
        }
    }

}
