// SPDX-License-Identifier: MIT
// GAS WHICH THIS CONTRACT COST  :: 802609 , WE HAVE TO LOWER THE GAS USED 
// GAS AFTER USING CONSTANT KEYWORD IN minimumUSD :: 783067 . 
//USING IMMUTABLE KEYWORD IN OWNER FURTHER REDUCES MORE GAS 

pragma solidity ^0.8.8;
//in this contract , we have to get funds from the users
// and creater should be able to withdraw the funds 
// also we have to set a minimum funding value in usd

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConvertor.sol";

contract FundMe{

   using PriceConvertor for uint256 ; 

    uint256 public constant minimumUSD = 50*1e18  ; // USING CONSTANT KEYWORD REDUCES THE GAS USED SIGNIFICANTLY 

    address[] public funders ; //here we create a array of addresses so that we can store the addresses of funders 
    mapping(address => uint256) public addressToAmountFunded ; // here we map address to name of the funder
 
  address public immutable owner ; 

  constructor() { // CONSTRUCTOR FUNCTION GETS CALLED IMMEDIATELY AFTER THE CONTRACT IS DEPLOYED 
         owner = msg.sender ;  // it immediately set up the msg.sender ( person who deployed the contract ) as the owner 
  }   


    function fund() public payable { // fund  funtion is payable and its public so that people can send us money 
        // for funding , we have to set a minimum amount that a user must send in order to go on with the transaction 
        require(msg.value.getConversionRate() > minimumUSD , "Didn't sent enough money , send more") ; 
        // here msg.value represents the amount of money sent. and we have set a cindition that if the money sent is not greater then 1e18 , then give the error msg 
        // if the condition is not met ,transaction will be cancelled and  all the processes done before that step will be revert back 
        //however , gas is still spent on for it but it the condition fails , then the gass which is left is sent back to the owner
        // here minimumusd is in terms of dollar and msg.value is in terms of etherium , so will convert it using oracle network 
        funders.push(msg.sender) ; // everytime a fund go through , we store the sender's address 
        addressToAmountFunded[msg.sender] = msg.value ; // also we map address to name of sender
    }

    modifier onlyOwner {
        require ( msg.sender == owner , " sender is not the owner") ; // make sure to keep the check on order of both these lines , as they are executed as written in line 
        _;
    }
    
    function withdraw() public onlyOwner { // by using only owner before the function , it checks onlyowner modifier
       
        // require ( msg.sender == owner , " sender is not the owner") ; 
        // instead of doing this check everytime , we can make a modifier . 
          // here we will select each donar's address through loop and then withdraw the fund . 
          for(uint256 funderIndex = 0 ; funderIndex < funders.length ; funderIndex++){ 
             address funder =   funders[funderIndex]  ; // funder gives address of funder of respective index
             addressToAmountFunded[funder] = 0 ;  // we make amount = 0 , ie we have withdrawn the funds . 
    }
          funders = new address[](0) ; // reseting the array of funders as we have already withdrawn the funds 


          //NOW WE WILL ACTAUALLY TRANSFER NATIVE CURRENCY TO WHOSOEVER CALLS THE WITHDRAW FUNCTION 

         // transfer :-                      here msg.sender = address 
                                        //         payable(msg.sender) = payable address 
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess,  ) = payable(msg.sender).call{value: address(this).balance}(""); // call returns 2 functions . one bool and other return data but here we are not interested in data 
        require(callSuccess, "Call failed"); // if call function fails , then it returns the error call failed
        
      // HERE ANYBODY CAN CALL WITHDRAW FUNCTION , SO WE WILL SET UP A OWNER of the contract USING CONSTRUCTOR
    } 
   // if somebody does any type of transaction with our contract without calling particular function , then receive and fallback function gets triggered 
      receive() external payable {
          fund() ; //here everytime somebody does any type of transaction with our contract without calling particular function , fund function gets triggered 
          
      }
      fallback() external payable {
          fund() ; 
      }

}
