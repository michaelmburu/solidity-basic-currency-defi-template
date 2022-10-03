// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

//This contract allows the owner to mint new coins
//Any user can send coins to each other with an ethereum key pair

/// @title Coin
/// @author Michael Mburu
/// @notice allows the owner to mint new coins
/// @dev Users can send coins to each other as long as they have an ethereum key pair.
contract Coin {
    //state variables (public - accessible to other contracts)
    address public minter;
    mapping(address => uint256) public balances;

    /// @notice emit a sent transaction to clients
    /// @dev No extra details
    /// @param from, to, amount
    event Sent(address from, address to, uint256 amount);

    error inSufficientBalance(uint256 requested, uint256 available);

    //initialize minter when running the contract
    constructor() {
        minter = msg.sender;
    }

    // onlyOwner: Restrict to contract owner
    modifier onlyOwner() {
        require(msg.sender == minter, "Only contract owner can execute");
        _;
    }

    /// @notice Mint new coins
    /// @dev Only the owner can send these coins
    /// @param receiver, amount
    function mint(address receiver, uint256 amount) public onlyOwner {
        balances[receiver] += amount;
    }

    /// @notice Send new tokens minted
    /// @dev Explain to a developer any extra details
    /// @param receiver, amount
    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender]) {
            revert inSufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
