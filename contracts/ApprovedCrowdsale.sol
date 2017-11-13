pragma solidity ^0.4.11;

import "./libs/Ownable.sol";

contract ApprovedCrowdsale is Ownable {

    mapping (address => bool) private approvedAddresses;

    function addApprovedAddress(address _address) onlyOwner external {
        approvedAddresses[_address] = true;
    }

    function removeApprovedAddress(address _address) onlyOwner external {
        approvedAddresses[_address] = false;
    }

    function isAddressApproved(address _address) public constant returns (bool) {
        if ( approvedAddresses[_address] == true ) {
            return true;
        }
        return false;
    }

    modifier onlyApproved() {
        require(isAddressApproved(msg.sender));
        _;
    }

}
