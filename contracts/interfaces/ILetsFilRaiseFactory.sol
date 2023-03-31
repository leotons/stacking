// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import './ILetsFilRaiseInfo.sol';
interface ILetsFilRaiseFactory is ILetsFilRaiseInfo {

    struct RaisePlan {
        address sponsor; //发起人地址
        uint64 minerId; //minerID
        uint256 raiseId; //募集ID
        address raiseAddress; //募集计划ID
    }
   
}