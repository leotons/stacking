// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ILetsFilRaiseInfo {
    struct RaiseInfo {
        uint256 id;             // 募集ID，合约内递增唯一标识
        uint256 targetAmount;   // 募集目标
        uint256 securityFund;   // 保证金
        uint256 securityFundRate; // 保证金比例
        uint256 deadline;       // 募集截止时间
        uint256 raiserShare;    // 募集者权益
        uint256 investorShare;  // 投资者权益
        uint256 servicerShare;  // 服务商权益
        address sponsor;        // 发起人地址
        uint256 companyId;      //发起单位id
    }

    struct NodeInfo {
        uint256 nodeSize;           // 节点大小
        uint256 sectorSize;         // 扇区大小
        uint256 sealPeriod;         // 封装周期
        uint256 nodePeriod;         // 节点有效期
        uint256 opsSecurityFund;    // 运维保证金
        address manager;            // 通过创建合约单独指定
        address opsSecurityFundPayer; // 缴纳运维保证金地址
        uint64 minerID;             // Miner ID
    }
}
