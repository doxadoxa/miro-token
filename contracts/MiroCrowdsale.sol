pragma solidity ^0.4.11;

import "./MiroToken.sol";
import "./TokenStorage.sol";
import "./libs/Ownable.sol";

contract MiroCrowdsale is Ownable {

    using SafeMath for uint;

    address public multisig;
    address public restricted;

    uint256 public collected;

    uint256 public startAt;
    uint256 public endAt;

    uint public restrictedPercent;


    MiroToken public token;
    TokenStorage public tokenStorage;

    uint public rate;

    uint256 public hardcap;
    uint256 public softcap;

    bool public finished;

    modifier whenActive() {
        require(now > startAt && now < endAt);
        _;
    }

    modifier notFinished() {
        require(!finished);
        _;
    }

    modifier underHardcap() {
        require(collected < hardcap );
        _;
    }

    function MiroCrowdsale(address _token, address _tokenStorage, address _multisig, address _restricted) {

        token = MiroToken(_token);
        tokenStorage = TokenStorage(_tokenStorage);

        finished = false;

        collected = 0;

        multisig = _multisig;
        restricted = _restricted;

        hardcap = 65000 * 1 ether;
        softcap = 5000 * 1 ether;

        rate = 1000;

        startAt = 1510604088;//1511092800;
        endAt = 1513684800;

        restrictedPercent = 35;
    }

    function calculateBonus(uint amount) private returns(uint) {
        uint bonusAmount = 0;

        /*
        Extra bonuses:
        - 0.5 to 10 ETH 15% MIRO
        - 10 to 50 ETH 20% MIRO
        - 50 to 100 ETH 25% MIRO
        - 100 ETH 30% MIRO
        */

        if ( amount > 100000 ) {
            bonusAmount = amount.mul(30).div(100);
        } else if ( amount > 50000 ) {
            bonusAmount = amount.mul(25).div(100);
        } else if ( amount > 10000 ) {
            bonusAmount = amount.mul(20).div(100);
        } else if ( amount > 5000 ) {
            bonusAmount = amount.mul(15).div(100);
        }

        return bonusAmount;
    }

    function createTokens() underHardcap whenActive private returns (uint) {
        multisig.transfer(msg.value);

        collected.add(msg.value);

        uint amount = rate.mul(msg.value).div(1 ether);
        uint totalAmount = amount.add(calculateBonus(amount));

        token.mint(tokenStorage, totalAmount);
        tokenStorage.addPaymentPromise(msg.sender, totalAmount);

        if ( collected > hardcap ) {
            finishCrowdsale();
        }
    }

    function finishCrowdsale() notFinished private {
        uint totalSupply = token.totalSupply();
        uint restrictedTokens = totalSupply.mul(restrictedPercent).div(100 - restrictedPercent);

        token.mint(restricted, restrictedTokens);

        token.finishMinting();

        finished = true;
    }

    function finish() onlyOwner notFinished external {
        finishCrowdsale();
    }

    function() payable external {
        createTokens();
    }

}
