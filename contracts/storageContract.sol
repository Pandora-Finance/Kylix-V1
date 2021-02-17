pragma solidity ^0.4.24;

interface IERC20{
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function transfer(address _to, uint256 _value) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

interface CToken{
    function redeemUnderlying(uint) external returns (uint);
    function mint(uint mintAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
}

contract FundStorage{

    mapping(uint => uint) public balance;
    mapping(uint => uint) public nftValue;
    address public pNFT = 0xa7a56246ff861F81cd431268C185dE2eBb752C99;
    address public USDT = 0xe704d4da53eab77b5eef1e490229c1f86bc30d47;
    address public aUSDT = 0x907e4f80FB77Fa20c82FE7Dc1C28Cd1Fb36C5E35;

    function addNft(uint _id, uint _amount) public{
        IERC20(USDT).transferFrom(msg.sender, address(this), _amount);
        IERC20(USDT).approve(aUSDT, _amount);
        CToken(aUSDT).mint(_amount);
        nftValue[_id] = _amount;
        balance[_id] = _amount;
    }

    function depositFunds(uint _id, uint _amount) public{
        IERC20(USDT).transferFrom(msg.sender, address(this), _amount);
        IERC20(USDT).approve(aUSDT, _amount);
        CToken(aUSDT).mint(_amount);
        balance[_id] = _amount;
    }

    function withdrawBalance(uint _id) public{
        require(msg.sender == IERC721(pNFT).ownerOf(_id), "Not Owner");
        CToken(aUSDT).redeemUnderlying(balance[_id]);
        IERC20(USDT).transfer(msg.sender, balance[_id]);
        balance[_id] = 0;
    }

}
