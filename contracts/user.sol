//SPDX-License-Identifier:MIT
pragma solidity >0.8.0;

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
contract user {
    uint256 immutable wireMaxPower;

    constructor(uint256 _wireMaxPower) {
        wireMaxPower = _wireMaxPower;
    }

    enum USERTYPE {
        producer,
        consumer,
        prosumer //both consumer and consumer
    }

    struct user {
        address userAdd;
        USERTYPE userType;
        uint256 productionRate; //Power production rate in kW
        uint256 demandRate; //Power demand rate in kW
    }

    user[] public Users;

    mapping(uint256 => mapping(uint256 => uint256)) u0_u1_distance;

    mapping(address => uint256) u0_address;

    mapping(uint256 => uint256[][]) u0_paths;
    mapping(uint256 => mapping(uint256 => uint256)) u0_ind_length;

    mapping(uint256 => mapping(uint256 => uint256)) u0_u1_currentTradeRate;

    event userAdded(uint256 userID, USERTYPE userType);

    function registerUser(
        address userAdd,
        USERTYPE userType,
        uint256 productionRate,
        uint256 demandRate
    ) public {
        Users.push(user(msg.sender, userType, productionRate, demandRate));
        uint256 l = Users.length;
        u0_address[msg.sender] = l - 1;
    }

    function updateProductionRate(uint256 productionRate) public {
        uint256 ind = u0_address[msg.sender];
        user storage _user = Users[ind];
        _user.productionRate = productionRate;
    }

    function updateDemandRate(
        uint256 demandRate
    ) public returns (bool success) {
        uint256 ind = u0_address[msg.sender];
        user storage _user = Users[ind];
        uint excessDemand = demandRate - _user.demandRate;
        if (excessDemand > 0) {
            uint[][] memory paths = u0_paths[ind];
            for (uint i = 0; i < paths.length; i++) {
                uint l = paths[i].length;
                uint source = paths[i][l - 1];
                user memory _source = Users[source];
                if (_source.productionRate >= excessDemand) {
                    bool confirm = true;
                    for (uint j = 0; j < l - 1; j++) {
                        if (
                            u0_u1_currentTradeRate[paths[i][j]][
                                paths[i][j + 1]
                            ] +
                                excessDemand >
                            wireMaxPower
                        ) {
                            confirm = false;
                        }
                    }
                    if (confirm) {
                        for (uint k = 1; k < l - 1; k++) {
                            u0_u1_currentTradeRate[paths[i][j]][
                                paths[i][j + 1]
                            ] =
                                u0_u1_currentTradeRate[paths[i][j]][
                                    paths[i][j + 1]
                                ] +
                                excessDemand;
                        }
                        _source.productionRate =
                            _source.productionRate +
                            excessDemand;
                    }
                }
            }
        }
    }
}
