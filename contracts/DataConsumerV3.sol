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

    event ConsoleLog(
        string console
    );

    uint80 public ROUNDID = 0;

    // ETH/USD 데이터 피드의 최신 데이터의 roundID 저장
    function getLatestData() public { 
        ( uint80 roundID, , , , ) = dataFeed.latestRoundData(); 
        ROUNDID=roundID;
    }

    // roundID를 입력하면 ETH/USD를 출력하는 함수
    function GETROUNDDATA(uint80 _RoundID) public view returns (uint256) {
        ( , int256 answer, , , ) = dataFeed.getRoundData(_RoundID);
        uint256 DECIMALS =  10 ** (dataFeed.decimals());
        uint256 answerUnsigned = uint256(answer);
        uint256 answerDecimalApplied = answerUnsigned / DECIMALS;
        return answerDecimalApplied;
    }

     // 이전 데이터 출력
    function getFormerPrice() public returns (uint256, uint256, uint256) {
        getLatestData();
        return (GETROUNDDATA(ROUNDID-3), GETROUNDDATA(ROUNDID-2), GETROUNDDATA(ROUNDID-1));
    }

    // 예상가 입력, 결과 출력
    function inputExpectedPrice(uint256 _userExpect) public returns(uint256, bool) { 
        // ROUNDID 가 설정되지 않았다면 
        if(ROUNDID == 0){
            getLatestData();
        }
        uint256 currentRoundAssetPrice = GETROUNDDATA(ROUNDID);
        uint256 positiveTenPercentFigure = (currentRoundAssetPrice + (currentRoundAssetPrice*10)/100);
        uint256 negativeTenPercentFigure = (currentRoundAssetPrice - (currentRoundAssetPrice*10)/100);
        // int256 errorFigure = int256(currentRoundAssetPrice - _userExpect);
        emit ConsoleLog("tenPercentFigure Set");
        bool win;

        if(_userExpect >= positiveTenPercentFigure) {
            win = false;
        }
        else if(_userExpect <= negativeTenPercentFigure) {
            win = false;
        }
        else{
            win = true;
        }

        return (currentRoundAssetPrice, win);
    }
}