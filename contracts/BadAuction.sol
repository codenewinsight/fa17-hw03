pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns (bool) {
		//if new value is higher than the highest bid
		if ((msg.value > highestBid)&& (0 != highestBid)){
			  //return funds to the current highest bidder
				if (!highestBidder.send(highestBid)) throw;

				//Update higest bid and bidder
				highestBidder = msg.sender;
				highestBid = msg.value;
				return true;
		}

		return false;
	}

	/* Give people their funds back */
	function () payable {
		revert();
	}
}
