pragma solidity ^0.4.24;

interface IERC20{
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function transfer(address _to, uint256 _value) external;
}

interface IERC721 {
    function ownerOf(uint256 tokenId) public view returns (address owner);
    function transferFrom(address from, address to, uint256 tokenId) public;
}

contract MarketPlace{
    mapping(uint=>address) public owner;

    function getIERC721Address() public pure returns(address){
        return 0xa7a56246ff861F81cd431268C185dE2eBb752C99;
    }

    function getUSDTAddress() public pure returns(address){
        return 0xe704d4da53eab77b5eef1e490229c1f86bc30d47;
    }

    function addNftForSale(uint _id, address _owner) public{
        owner[_id] = _owner;
    }

    function sellNft(uint _id, uint _amount, address _to){
         IERC20(getUSDTAddress()).transferFrom(_to, owner[_id], _amount);
         IERC721(getIERC721Address()).transferFrom(address(this), _to, _id);
    }
}
