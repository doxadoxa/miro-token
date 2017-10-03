pragma solidity ^0.4.11;

import "./libs/Ownable.sol";
import "./MiroToken.sol";

contract MiroStartDistribution is Ownable {

    MiroToken public token;

    mapping (address => uint256) distributors;

    function MiroStartDistribution(address _token) {
        token = MiroToken(_token);
    }

    function putDistributor(address _address, uint256 _amount) onlyOwner {
        distributors[_address] = _amount;
    }

    function isDistributor(address _address) public constant returns (bool) {
        if( distributors[_address] != uint256(0x0) ) {
            return true;
        }
        return false;
    }

    function distribute() external {
        require(isDistributor(msg.sender));
        
        address distributor = _address;
        uint256 amount = distributors[_address];

        token.mint(distributor, amount);
    }

}
