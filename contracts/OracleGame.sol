// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3; 

contract OracleGame {

    address payable public owner; 
    // 각 회차는 gameId를 key로 저장되며 새로운 회차가 진행될 시 gameId를 증가시켜준다.
    // 각 회차마다 사용자는 하나의 Bet을 생성할 수 있고 이를 Double Mapping을 통해 관리한다.
    mapping(uint256 => mapping(address => Bet)) public betsHistory; 

    uint256 public gameId; // gameId의 Increment를 통해 한 회차의 베팅 종료시 다음 회차의 베팅으로 넘어가게끔 한다
    uint public assetPrice; // 현재는 임의로 assetPrice를 설정(추후에 ChainLink를 통해 1일전,2일전,3일전,현재의 assetPrice를 가져온다)
    bool public bettingOpen; // Betting 활성화 상태

    struct Bet {
        uint amount;
        uint prediction;
        bool exists;
    }

    constructor() {
        owner = payable(msg.sender);
        bettingOpen = true;
        gameId = 0;
    }

    // 한 차례의 게임이 끝났을시(다음날로 넘어갔을시) 그 다음 회차의 게임을 위해 gameId++
    function gameInitialization(uint256 _asset) public {
        gameId++; // GameId Increment
        bettingOpen = true; // Betting 활성화
        // 실제 Chain Link 연결시 어떤 asset으로 Betting을 열지 _asset input을 통해 설정한다.

    }

    // 현재의 gameId를 key로 유저는 Betting을 시행한다
    function placeBet(uint _prediction) public payable {
        Bet storage betInstance =  betsHistory[gameId][msg.sender]; // betsHistory에서 gameId와 msg.sender의 정보를 통해 Bet structure 객체를 가져온다. (storage를 통해 call by reference)
        require(bettingOpen, "Betting is closed");
        require(!betInstance.exists, "User already placed a bet");

        betInstance.amount = msg.value;
        betInstance.prediction = _prediction;
        betInstance.exists = true;
    }

    // 현재는 임의로 asset price를 설정하는 함수 생성
    function setAssetPrice(uint price) public {
        require(msg.sender == owner, "Only the owner can set the price");
        assetPrice = price;
        bettingOpen = false;
    }

    // 사용자가 현재 회차에 자신의 Bet이 존재시 해당 Bet에 대한 결과를 확인하는 함수
    function redeemResult() public {
        Bet storage betInstance =  betsHistory[gameId][msg.sender];
        address payable payableMsgSender = payable(msg.sender);
        require(betInstance.exists, "User's bet doesn't exist");
        if (
            betInstance.prediction <= assetPrice * 110 / 100 &&
            betInstance.prediction >= assetPrice * 90 / 100)
        {
            payableMsgSender.transfer(betInstance.amount * 2);
            betInstance.exists = false;
        }
    }

    // 서비스 owner가 해당 Smart Contract에 저장된 ETH를 모두 출금하는 function
    function withdrawAllEth() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        owner.transfer(address(this).balance);
    }
}