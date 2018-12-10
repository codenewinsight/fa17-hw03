pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {
	/* New data structure, keeps track of refunds owed to ex-highest bidders */
	mapping(address => uint256) refunds;

	/* Bid function, shifts to pull paradigm
	 * Must return true on successful send and/or bid, bidder
	 * reassignment
	 * Must return false on failure and allow people to
	 * retrieve their funds
	 */
	function bid() payable external returns(bool) {
		//if new value is higher than the highest bid
		if (msg.value > highestBid) {
			  //Set up refund for the previous highest bid
				refunds[highestBidder] = highestBid;

				//Update higest bid and bidder
				highestBidder = msg.sender;
				highestBid = msg.value;
				return true;
		}

		return false;
	}

	/* New withdraw function, shifts to pull paradigm */
	function withdrawRefund() external returns(bool) {
		if (!msg.sender.send(refunds[msg.sender])) throw;
	}

	/* Allow users to check the amount they can withdraw */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}

	/* Give people their funds back */
	function () payable {
		revert();
	}
}
