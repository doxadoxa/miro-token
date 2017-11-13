var SafeMath = artifacts.require("./math/SafeMath.sol");
var MiroToken = artifacts.require("./MiroToken.sol");
var TokenStorage = artifacts.require("./TokenStorage.sol");
var MiroStartDistribution = artifacts.require("./MiroStartDistribution.sol");
var MiroPresale = artifacts.require("./MiroPresale.sol");
var MiroCrowdsale = artifacts.require("./MiroCrowdsale.sol");



module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, MiroToken);
  deployer.link(SafeMath, TokenStorage);
  deployer.link(SafeMath, MiroStartDistribution);
  deployer.link(SafeMath, MiroPresale);
  deployer.link(SafeMath, MiroCrowdsale);


  var multisig = web3.eth.accounts[1];
  var restricted = web3.eth.accounts[2];

  deployer.deploy(MiroToken).then(function() {
      deployer.deploy(TokenStorage, MiroToken.address).then(function() {
          deployer.deploy(MiroStartDistribution, MiroToken.address, TokenStorage.address);
          deployer.deploy(MiroCrowdsale, MiroToken.address, TokenStorage.address, multisig, restricted);
      });
  });
};
