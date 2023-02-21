//SPDX-License-Identifier:MIT
pragma solidity >0.8.0;

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
contract user {
    struct user {
        uint256 userID; //User ID (unique to user)
        uint256 energyPR; //Energy Production Rate
        uint256 energyRR; //Energy Requirement Rate
        uint256 geolocation; //GPS Location of user
        user[] peers; //User's peers
    }

    struct trade {
        uint256 energyTradeRate;
        uint256 timeStart;
        uint256 timeEnd;
    }

    event userAdded(
        uint256 userID,
        uint256 energyPR, //Energy Production Rate
        uint256 energyRR, //Energy Requirement Rate
        uint256 geolocation //GPS Location of user
    );

    user[] public users;

    function registerUser(user memory _user) public returns (bool success) {}

    function changeEnergyPR() public returns (bool success) {}

    function changeEnergyRR() public returns (bool success) {}
}
