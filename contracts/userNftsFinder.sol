pragma solidity 0.4.24;

interface Storage{
    function balance(uint _id) external view returns (uint256);
    function nftValue(uint _id) external view returns (uint256);
}

contract UserNfts{
    address public storageContract = 0xde4E8A668163b017813e4c85fa1AdE17a9A9c700;

    function tokensOfOwner(uint id) external view returns(uint, uint) {
        return (Storage(storageContract).nftValue(id),  Storage(storageContract).balance(id));
    }
}
