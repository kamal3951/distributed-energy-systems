//SPDX-License-Identifier:MIT
pragma solidity >0.8.0;

import "./user.sol";

contract peer {
    function searchPeer(user _user) private returns (bool success) {}

    function addPeer(user _user) private returns (bool success) {}

    function startTrade(user source, user sink)
        private
        returns (uint256 tradeRate)
    {}

    function endTrade(user source, user sink) private returns (uint256 time) {}
}
