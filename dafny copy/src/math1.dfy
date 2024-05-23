
include "util/number.dfy"
include "util/maps.dfy"
include "util/tx.dfy"


import opened Number
import opened Maps
import opened Tx

 class Math1 {
    function Add(x: u256, y: u256) : u256 
    requires (x as nat) + (y as nat) <= MAX_U256 as nat{
        x + y
    }

    function Sub(x: u256, y: u256) : u256
    requires (x as nat) - (y as nat) >= 0 as nat {
        x - y
    }

    method Mul(x: u256, y: u256) returns (r: u256)
    requires (x as nat) * (y as nat) <= MAX_U256 as nat
    {
        r := x * y;
    }


    
    
 } 
  
  