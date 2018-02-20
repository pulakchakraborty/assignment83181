pragma solidity ^0.4.17;
import "./UserManagement.sol";

/**
 * Users and their respective permission
 */

contract User {

    // State variables
    bytes32 private userId;
    bytes32 private userName;
    address private userAddress;
    
    mapping(bytes32 => Record) private records;
    /**
     * General record structure where every record has an unique identifier and a name
     */
    struct Record {
        bytes32 id;     // should be unique -
        bytes32 name;
    }

    mapping (address => bool) private _permission1Flag;
    
    address UMContractAddress;
    UserManagement userManagement = UserManagement(UMContractAddress);

    // Constructor function - register the user in the system
    function User(bytes32 _userId) public {
        userAddress = msg.sender;
        userId = _userId;
        userManagement.create(this, _userId);
    }

    // Establish the modifiers for future user
    // Place restriction on the user
    modifier onlyBy() {
        require(msg.sender == userAddress);
        _;
    }

    // Add a particular permission as a constraint
    modifier hasPermission1() {
        require(_permission1Flag[msg.sender] == true || userAddress == msg.sender);
        _;
    }

    // getter to fetch user's name
    function getUserName() public constant returns (bytes32) {
        return userName;
    }

    // fetch user's id
    function getUserId() public constant returns (bytes32) {
        return userId;
    }

    // set the user's name
    function setUserName(bytes32 _userName) public onlyBy {
        userName = _userName;
    }

    // Adds a record only if the user has a permission (we call this Permission1)
    function addRecord(bytes32 _recordId, bytes32 _recordName) public hasPermission1 returns(bool) {
        Record storage record = records[_recordId];
        if (record.id != _recordId) {
            record.id = _recordId;
            record.name = _recordName;
            return true;
        }
    }


    // Provide permission to an address
    function addPermission1(address _address) public onlyBy {
        _permission1Flag[_address] = true;
    }

    // Remove permission from an address
    function removePermission1(address _address) public onlyBy {
        _permission1Flag[_address] = false;
    }
}
