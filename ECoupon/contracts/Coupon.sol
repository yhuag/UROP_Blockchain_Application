pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract Coupon is StandardToken {
  // Configuration
  string public constant name = "E-Coupon General Grant";
  string public constant symbol = "EGG";
  uint256 public startTime;
  uint256 public endTime;

  uint8 public constant DECIMALS = 18;
  uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));

  // Owner of the contract
  address public owner;

  // Balance for each account
  mapping(address => uint256) balances;

  // Balace used for each account
  mapping(address => uint256) balancesUsed;

  // Approval of transfer
  mapping(address => mapping(address => uint256)) allowed;

  // Functions with this modifier can only be executed by the owner
  modifier onlyOwner() {
    assert(msg.sender == owner);
    _;
  }

  // Check whether the redeem time is between the span of startTime and endTime.
  modifier isValidRedeemTime(){
    require(startTime <= now);
    require(endTime >= now);
    _;
  } 

  // Constructor
  function Coupon(uint256 _startTime, uint256 _endTime) {
    require(_endTime >= _startTime);

    owner = msg.sender;
    balances[owner] = INITIAL_SUPPLY;
    totalSupply = INITIAL_SUPPLY;
    startTime = _startTime;
    endTime = _endTime;
  }

  // Update the balances/balancesUsed of the user when coupon redeemed
  function redeem(uint256 amount) public isValidRedeemTime returns (bool success) {
    require(balances[msg.sender] >= amount);

    balancesUsed[msg.sender].add(amount);
    balances[msg.sender].sub(amount);

    success = true; 
  }

  // Only the owner can check the balance of a specific user
  function checkBalances(address user) onlyOwner constant returns (uint256 _balances) {
    _balances = balances[user];
  }

  // Only the owner can check the balanceUsed of a specific user
  function checkBalancesUsed(address user) onlyOwner constant returns (uint256 _balancesUsed) {
    _balancesUsed = balancesUsed[user];
  }

  // Anyone can check their personal balances
  function getAccountBalances() public constant returns (uint256 _balances) {
    _balances = balances[msg.sender];
  }

  // Anyone can check their personal balances
  function getAccountBalancesUsed() public constant returns (uint256 _balances) {
    _balances = balancesUsed[msg.sender];
  }
}
