// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;


contract TestOracle {
    mapping(address => uint256) private prices;

    // @dev returns the asset price in wei(기존 ChainLink는 eth의 단위로 return하는듯)
    function getAssetPrice(address _asset) public view returns (uint256) {
        return prices[_asset];
    }

    // @dev sets the asset price in wei(IPriceOracle에 따르면)
    function setAssetPrice(address _asset, uint256 _price) public {
        prices[_asset] = _price;
    }
}
