var SafeMath = artifacts.require("./math/SafeMath.sol");
var MiroToken = artifacts.require("./MiroToken.sol");
var MiroStartDistribution = artifacts.require("./MiroStartDistribution.sol");
var MiroPresale = artifacts.require("./MiroPresale.sol");
var MiroCrowdsale = artifacts.require("./MiroCrowdsale.sol");



module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, MiroToken);
  deployer.link(SafeMath, MiroStartDistribution);
  deployer.link(SafeMath, MiroPresale);
  deployer.link(SafeMath, MiroCrowdsale);


  var startAt = Math.round(Date.now()/1000);
  var period = 21;
  var multisig = web3.eth.accounts[1];
  var rate = 1000;
  var restricted = web3.eth.accounts[2];
  var hardcap = 10000000;
  var restrictedPercent = 40;


  deployer.deploy(MiroToken).then(function() {
      deployer.deploy(MiroStartDistribution, MiroToken.address);
      deployer.deploy(MiroPresale, MiroToken.address, multisig, startAt, period, rate);
      deployer.deploy(MiroCrowdsale, MiroToken.address, multisig, restricted, startAt, period, rate, hardcap, restrictedPercent);
  });
};
