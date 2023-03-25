// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
//LIBRARY FOR FUNCTIONS USED IN THE CONTRACT 

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    
 
 function getPrice() internal view returns (uint256) { 
     //we have to get price of etherium from outside of contract 
        // for it , we need 2 things , ABI and ADDRESS 
        // address is 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
         AggregatorV3Interface priceFeed  = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e) ;                           
        (, int price , ,,) = priceFeed.latestRoundData() ; // aggretarv3 function gives many data , but we need only price , so we write only price
       // here the price is in term of dollars and contains less decimals then msg.vale  so we add decimals in front of it so that decimals match with the msg.value function
        return uint256(price * 1e10) ; 
    }                           
   
     function getversion()internal view returns (uint256) { // for ABI 
     AggregatorV3Interface priceFeed  = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e) ;
     return priceFeed.version() ;    // HERE ER ARE GIVING A ABI CALL TO THE aggregatorV3Interface 
    }    
     
      // NOW WE HAVE PRICE IN DOLLAARS AND GETVALUE IN TERMS OF ETHERIUM , SO WE NOW WANT ETH IN TERMS OF USD 

    function getConversionRate ( uint256 ethAmount ) internal view returns ( uint256) {
          uint256 ethPrice =  getPrice() ; 
          uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18 ; 
          return ethAmountInUsd ; 
          /*
          for eg = ethamount = 1.000000000000000000 
                   ethprice ie market price  = 3000.000000000000000000  usd per eth
                   total ethamountinusd= 3000
          */
    }
}
