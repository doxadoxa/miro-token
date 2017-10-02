pragma solidity ^0.4.11;

import "./MiroToken.sol";
import "./libs/Ownable.sol";

contract MiroCrowdsale is Ownable {

    using SafeMath for uint;

    address public multisig;
    address public restricted;

    uint256 public startAt;
    uint256 public endAt;

    uint public restrictedPercent;

    MiroToken public token;

    uint public rate;

    uint public hardcap;

    bool public finished;

    modifier whenActive() {
        require(now > startAt && now < endAt);
        _;
    }

    modifier notFinished() {
        require(finished == false);
        _;
    }

    modifier underHardcap() {
        require(token.totalSupply() < hardcap );
        _;
    }

    function MiroCrowdsale(address _token, address _multisig, address _restricted, uint256 _startAt, uint _period, uint _rate, uint _hardcap, uint _restrictedPercent) {

        token = MiroToken(_token);

        finished = false;

        multisig = _multisig;
        restricted = _restricted;

        startAt = _startAt;
        endAt = _startAt + _period * 1 days;

        rate = _rate;
        hardcap = _hardcap;
        restrictedPercent = _restrictedPercent;
    }

    function calculateBonus(uint amount) private returns(uint) {
        uint bonusAmount = 0;

        if ( amount > 10000 ) {
            bonusAmount = amount.mul(5).div(100);
        } else if ( amount > 100000 ) {
            bonusAmount = amount.mul(10).div(100);
        } else if ( amount > 1000000 ) {
            bonusAmount = amount.mul(20).div(100);
        }

        return bonusAmount;
    }

    function createTokens() underHardcap private returns (uint) {
        multisig.transfer(msg.value);

        uint amount = rate.mul(msg.value).div(1 ether);
        uint totalAmount = amount.add(calculateBonus(amount));

        token.mint(msg.sender, totalAmount);
    }

    function finish() onlyOwner notFinished external {
        uint totalSupply = token.totalSupply();
        uint restrictedTokens = totalSupply.mul(restrictedPercent).div(100);

        token.mint(restricted, restrictedTokens);

        token.finishMinting();

        finished = true;
    }

    function() payable external {
        createTokens();
    }

}