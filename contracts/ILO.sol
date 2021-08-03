//SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./Oppa.sol";
import "./utils/SafeMath.sol";

contract ILO {
    using SafeMath for uint256;

    Oppa public token;
    address public owner;
    bool isActive = false;

    //price of per token in BNB
    uint256 pricePerToken = 10000000000000000;

    uint256 public availableToken;
    uint256 MinPurchase = 1 * 10**18; // 1 OPPA
    uint256 MaxPurchase = 10000 * 10**18; // 10,000 OPPA

    event Purchase(address from, uint256 _amount);

    constructor() public {
        owner = msg.sender;
    }

    function initialise(Oppa _token, uint256 _availabletoken) public onlyOwner {
        token = _token;

        availableToken = _availabletoken;
    }

    function startEnd() public onlyOwner {
        if (isActive == false) {
            isActive = true;
        } else {
            isActive = false;
        }
    }

    function deposite() public payable {
        _transfer(msg.value);
    }

    //Function to receive plan ether & send the token equivalent to msg.value
    receive() external payable {
        _transfer(msg.value);
    }

    function _transfer(uint256 _msg) internal {
        require(isActive == true, "Presale has ended");
        uint256 sendvalue = _msg.div(pricePerToken);
        require(availableToken >= sendvalue, "Insufficent token");
        availableToken = availableToken.sub(sendvalue * 1e18);
        token.transfer(msg.sender, sendvalue * MinPurchase);
        emit Purchase(msg.sender, sendvalue);
    }

    function withdrawEth(address payable _to, uint256 _amount)
        external
        onlyOwner
    {
        _to.transfer(_amount);
    }

    function WithdrawToken(uint256 _amount) external onlyOwner {
        Oppa(token).transfer(msg.sender, _amount);
    }

    function transferOwnership(address _owner) public {
        require(msg.sender == owner);
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
