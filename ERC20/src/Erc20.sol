// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OperaToken {
    // state varables
    string public tokenName = "Opera";
    string public tokenSymbol = "OPR";
    uint8 public constant decimals = 18;

    // Core token storage
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // token events 
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // 20,000 token supply with 18 decimals
        _mint(msg.sender, 20_000 * 10 ** uint256(decimals));
    }

    // ERC20 required functions
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        uint256 current = _allowances[from][msg.sender];
        require(current >= value, "ERC20: insufficient allowance");

        unchecked {
            _allowances[from][msg.sender] = current - value;
        }
        emit Approval(from, msg.sender, _allowances[from][msg.sender]);

        _transfer(from, to, value);
        return true;
    }

    // Internal logic
    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "ERC20: transfer from zero");
        require(to != address(0), "ERC20: transfer to zero");

        uint256 fromBal = _balances[from];
        require(fromBal >= value, "ERC20: insufficient balance");

        unchecked {
            _balances[from] = fromBal - value;
            _balances[to] += value;
        }

        emit Transfer(from, to, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from zero");
        require(spender != address(0), "ERC20: approve to zero");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _mint(address to, uint256 value) internal {
        require(to != address(0), "ERC20: mint to zero");

        _totalSupply += value;
        _balances[to] += value;
        emit Transfer(address(0), to, value);
    }
}
