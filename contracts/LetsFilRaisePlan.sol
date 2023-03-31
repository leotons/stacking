// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/ILetsFilRaisePlan.sol";
import "./interfaces/ILetsFilRaiseInfo.sol";

enum RaiseState { 
    WaitingStart,   
    WaitingPayOPSSecurityFund,
    WaitingSPSign, 
    Raising,  
    Closed,  
    Success,
    Failure   
}

enum NodeState {
    WaitingStart,
    Started,
    Delayed,
    End,
    Success,
    Failure,
    Terminate
}


contract LetsFilRaisePlan is ILetsFilRaisePlan {

    uint256 public immutable PLEDGE_MIN_AMOUNT = 10 ether;

    RaiseState public raiseState;
    NodeState public nodeState;

    uint256 public raiseID;
    RaiseInfo public raiseInfo;
    NodeInfo public nodeInfo;
    uint256 public totalReward;
    uint256 public vestTotalReward;

    uint256 public pledgeTotalAmount;
    mapping(address => uint256) public pledgeRecord;
    mapping(address => uint256) public withdrawRecord;

    uint64 public startSealTime;
    uint256 public sealUsedAmount;

    // events
    event eDepositOPSSecurityFund(uint256 raiseID, address sender, uint256 amount);

    // errors
    string constant PERMISSION_ERROR = "No permission";

    constructor(uint256 _raiseID, RaiseInfo memory _raiseInfo, NodeInfo memory _nodeInfo) payable {
        raiseID = _raiseID;
        raiseInfo = _raiseInfo;
        nodeInfo = _nodeInfo;
        raiseState = RaiseState.WaitingPayOPSSecurityFund;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function specifyOpsPayer(address payer) external {
        require(msg.sender == raiseInfo.sponsor, PERMISSION_ERROR);
        nodeInfo.opsSecurityFundPayer = payer;
    }

    function payOpsSecurityFund() payable external {
        require(raiseState == RaiseState.WaitingPayOPSSecurityFund, "Raise state must be WaitingPayOPSSecurityFund");
        require(msg.value == nodeInfo.opsSecurityFund, "Wrong ops security fund");
        require(msg.sender == nodeInfo.opsSecurityFundPayer, PERMISSION_ERROR);
        require(pledgeRecord[msg.sender] == 0, "OPSSecurityFund has been paid");

        pledgeRecord[msg.sender] = msg.value;
        pledgeTotalAmount = msg.value;

        raiseState = RaiseState.WaitingSPSign;
        emit eDepositOPSSecurityFund(raiseID, msg.sender, msg.value);
    }

    
}