// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DataConsumerV3 {
    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306 // * Network: Sepolia, * Data Feed: ETH/USD
        );
    }

    uint80 public latestRoundID;

    function getLatestRoundID() public { //  ETH/USD 데이터 피드의 최신 데이터의 roundID 저장
        ( uint80 roundID, , , , ) = dataFeed.latestRoundData(); 
        latestRoundID=roundID;
    }

    function getRoundPrice(uint80 _RoundID) public view returns (int256) { // roundID를 입력하면 ETH/USD를 출력하는 함수
        ( , int256 answer, , , ) = dataFeed.getRoundData(_RoundID);
        return answer;
    }

    function getFormerPrice() public view returns (int256, int256, int256) { // 이전 데이터 출력
        return (getRoundPrice(latestRoundID-3), getRoundPrice(latestRoundID-2), getRoundPrice(latestRoundID-1));
    }
}