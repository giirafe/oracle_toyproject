# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

```
<Chainlink를 사용한 Oracle 게임 만들기>

1. 게임 내에서 사용할 수 있는 유틸리티 토큰을 만들어, 내 노드에 발행하기

2. Chainlink에서 3일 전, 2일 전, 1일 전 이더리움 종가를 불러들여((KST) 09:00) 콘솔에 출력

3. 게임 플레이어는 출력된 가격 정보를 보고 오늘 아침 9시의 종가를 예상하고, 스마트컨트랙트에 입력하고 동시에 토큰을 베팅

4. 플레이어가 입력한 가격과 실제 가격을 비교해, 오차 범위가 +-10% 이내일 경우 베팅한 토큰을 2배로 되돌려줌. 오차범위를 초과했을 경우 토큰 몰수

5. 입력 가격, 실제 가격, 오차범위, 성공/실패, 되돌려주는/몰수하는 토큰의 양 콘솔에 출력

```
