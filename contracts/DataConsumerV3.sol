// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DataConsumerV3 {
    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306 // * Network: Sepolia, * Data Feed: ETH/USD
        );
    }

    event GameResult(
        address indexed gamePlayer,
        bool win,
        uint256 winnings
    );

    // uint256 public DECIMALS;

    // function getDecimals() public { // 소수점 자리수 찾기
    //     DECIMALS = dataFeed.decimals();
    // }

    uint80 public ROUNDID;

    function getLatestData() public { //  ETH/USD 데이터 피드의 최신 데이터의 roundID 저장
        ( uint80 roundID, , , , ) = dataFeed.latestRoundData(); 
        ROUNDID=roundID;
    }

    function GETROUNDDATA(uint80 _RoundID) public view returns (uint256) { // roundID를 입력하면 ETH/USD를 출력하는 함수
        ( , int256 answer, , , ) = dataFeed.getRoundData(_RoundID);
        uint256 DECIMALS =  10 ** (dataFeed.decimals());
        uint256 answerUnsigned = uint256(answer);
        uint256 answerDecimalApplied = answerUnsigned / DECIMALS;
        return answerDecimalApplied;
    }

    function getFormerPrice() public view returns (uint256, uint256, uint256) { // 이전 데이터 출력
        return (GETROUNDDATA(ROUNDID-3), GETROUNDDATA(ROUNDID-2), GETROUNDDATA(ROUNDID-1));
    }

    function inputExpectedPrice(uint256 _expect) public view returns(uint256, uint256, uint256, string memory) { // 예상가 입력, 결과 출력
        uint256 tenPercent = (GETROUNDDATA(ROUNDID)*10)/100;
        string memory result;
        if(GETROUNDDATA(ROUNDID)-_expect >=tenPercent) {
            result = "Failed";
        }
        else if(_expect-GETROUNDDATA(ROUNDID) >=tenPercent) {
            result = "Failed";
        }
        else{
            result ="Successed";
        }
        return ( _expect, GETROUNDDATA(ROUNDID), GETROUNDDATA(ROUNDID)-_expect, result);
    }
}