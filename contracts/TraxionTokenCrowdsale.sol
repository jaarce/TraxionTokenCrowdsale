pragma solidity ^0.4.18;

import "../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/token/MintableToken.sol";


/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract TraxionToken is MintableToken {

  string public constant name = "Traxion Token Crowdsale"; // solium-disable-line uppercase
  string public constant symbol = "TXN"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

  mapping (address => uint) balances;
  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  function TraxionToken() {
        balances[tx.origin] = 500000000;
    }
  
  function sendCoin(address receiver, uint amount) returns(bool sufficient) {
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Transfer(msg.sender, receiver, amount);
        return true;
    }

}


/**
 * @title SampleCrowdsale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract TraxionTokenCrowdsale is CappedCrowdsale, RefundableCrowdsale {

  function TraxionTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet) public
    CappedCrowdsale(_cap)
    FinalizableCrowdsale()
    RefundableCrowdsale(_goal)
    Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    //As goal needs to be met for a successful crowdsale
    //the value needs to less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);
  }



  function createTokenContract() internal returns (MintableToken) {
    return new TraxionToken();
  }

}