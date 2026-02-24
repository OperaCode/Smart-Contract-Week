// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract PropertyManager is AccessControl {
    
    using SafeERC20 for IERC20;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    IERC20 public immutable token;

    constructor(IERC20 _token) {
        token = _token;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    modifier onlyManager() {
        if (!hasRole(MANAGER_ROLE, msg.sender)) {
            revert("Not manager");
        }
        _;
    }

    struct Property {
        uint256 id;
        address owner;
        string name;
        string location;
        string details;
        uint256 price;
        bool forSale;
        bool exists;
    }

    Property[] private properties;
    uint256 public propertyCount;

    event PropertyCreated(
        uint256 indexed id,
        address indexed owner,
        uint256 price
    );
    event PropertyRemoved(uint256 indexed id);
    event PropertyBought(
        uint256 indexed id,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );
    event PropertyForSaleUpdated(
        uint256 indexed id,
        bool forSale,
        uint256 price
    );

    function createProperty(
        address _owner,
        string calldata _name,
        string calldata _location,
        string calldata _details,
        uint256 _price
    ) external onlyManager {
        require(_owner != address(0), "Zero owner");
        require(bytes(_name).length > 0, "Name required");
        require(_price > 0, "Price must be > 0");

        propertyCount++;

        properties.push(
            Property({
                id: propertyCount,
                owner: _owner,
                name: _name,
                location: _location,
                details: _details,
                price: _price,
                forSale: true,
                exists: true
            })
        );

        emit PropertyCreated(propertyCount, _owner, _price);
    }

    function removeProperty(uint256 _id) external onlyManager {
        require(_id > 0 && _id <= propertyCount, "Invalid id");
        uint256 index = _id - 1;

        require(properties[index].exists, "Already removed");

        properties[index].exists = false;
        properties[index].forSale = false;
        properties[index].price = 0;

        emit PropertyRemoved(_id);
    }

    function setForSale(uint256 _id, bool _forSale, uint256 _price) external {
        require(_id > 0 && _id <= propertyCount, "Invalid id");
        uint256 index = _id - 1;

        Property storage p = properties[index];
        require(p.exists, "Removed");
        require(
            msg.sender == p.owner || hasRole(MANAGER_ROLE, msg.sender),
            "Not owner or manager"
        );

        p.forSale = _forSale;
        if (_forSale) {
            require(_price > 0, "Price must be > 0");
            p.price = _price;
        } else {
            p.price = 0;
        }

        emit PropertyForSaleUpdated(_id, p.forSale, p.price);
    }

    function buyProperty(uint256 _id) external {
        require(_id > 0 && _id <= propertyCount, "Invalid id");
        uint256 index = _id - 1;

        Property storage p = properties[index];

        require(p.exists, "Removed");
        require(p.forSale, "Not for sale");
        require(p.price > 0, "Bad price");
        require(msg.sender != p.owner, "Owner can't buy");

        address seller = p.owner;
        uint256 price = p.price;

        token.safeTransferFrom(msg.sender, seller, price);

        p.owner = msg.sender;
        p.forSale = false;

        emit PropertyBought(_id, seller, msg.sender, price);
    }

    function getAllProperties() external view returns (Property[] memory) {
        return properties;
    }
}
