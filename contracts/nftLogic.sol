pragma solidity ^0.4.24;

interface IERC20{
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function transfer(address _to, uint256 _value) external;
    function allowance(address owner, address spender) public view returns (uint256);
    function approve(address spender, uint256 amount) public returns (bool);
}

interface IERC721 {
    function ownerOf(uint256 tokenId) public view returns (address owner);
    function _mint(address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}

interface Storage{
    function addNft(uint _id, uint _amount) external;
    function depositFunds(uint _id, uint _amount) external;
    function withdrawBalance(uint _id) external;
    function balance(uint _id) external view returns (uint256);
    function nftValue(uint _id) external view returns (uint256);
}

interface IMarketPlace{
    function addNftForSale(uint _id, address _owner) external;
    function sellNft(uint _id, uint _amount, address _to) external;
}

contract LogicContract{

    function getNFTAddress() internal view returns(address){
        return 0xa7a56246ff861F81cd431268C185dE2eBb752C99;
    }

    function getUSDTddress() internal view returns(address){
        return 0xe704d4da53eab77b5eef1e490229c1f86bc30d47;
    }

    function getStorageContractAddress() internal view returns(address){
        return 0xde4E8A668163b017813e4c85fa1AdE17a9A9c700;
    }

    function getMarketPlaceAddress() internal view returns(address){
        return 0x160dFD31624c46c20cB03d91676FDca8B62b967B;
    }

    function createNft(address owner, uint id, uint amount) public{
        IERC721(getNFTAddress())._mint(owner, id);
        IERC20(getUSDTddress()).approve(getStorageContractAddress(), amount);
        Storage(getStorageContractAddress()).addNft(id, amount);
    }

    function withdraw(uint id) public{
        Storage(getStorageContractAddress()).withdrawBalance(id);
    }

    function depositFunds(uint id, uint amount) public{
        IERC20(getUSDTddress()).approve(getStorageContractAddress(), amount);
        Storage(getStorageContractAddress()).depositFunds(id, amount);
    }

    function transfer(address to, uint id) public{
        IERC721(getNFTAddress()).transferFrom(address(this),to, id);
    }

    function createAndSell(address owner, uint id, uint amount) public{
        IERC721(getNFTAddress())._mint(getMarketPlaceAddress(), id);
        IERC20(getUSDTddress()).approve(getStorageContractAddress(), amount);
        Storage(getStorageContractAddress()).addNft(id, amount);
        IMarketPlace(getMarketPlaceAddress()).addNftForSale(id, owner);
    }

    function putOnSale(address owner, uint id) public{
        IMarketPlace(getMarketPlaceAddress()).addNftForSale(id, owner);
        IERC721(getNFTAddress()).transferFrom(owner,getMarketPlaceAddress(), id);
    }

    function buyNft(uint _id, uint _amount) public{
        IERC20(getUSDTddress()).approve(getMarketPlaceAddress(), _amount);
        IMarketPlace(getMarketPlaceAddress()).sellNft(_id, _amount, address(this));
    }
}
