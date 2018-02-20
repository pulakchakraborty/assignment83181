pragma solidity ^0.4.17;
import "./User.sol";

/**
 * This contract is used for Users Management, i.e. CRUD operations
 */

contract UserManagement {

    // state variables
    mapping (bytes32 => User) private newUser;
    mapping (bytes32 => bool) private checkUser;

    // establish the modifiers for future use
    modifier noUserExists(bytes32 userFlag) {
        require(!checkUser[userFlag]);
        _;
    }

    modifier userExists(bytes32 userFlag) {
        require(checkUser[userFlag]);
        _;
    }

    // CRUD Operations
    // create user function
    function create(User _newUser, bytes32 userFlag) public noUserExists(userFlag)
    {
        checkUser[userFlag] = true;
        newUser[userFlag] = _newUser;
    }

    // remove user function
    function remove(bytes32 userFlag) public userExists(userFlag)
    {
        checkUser[userFlag] = false;
    }

}
