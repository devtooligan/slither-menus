// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Zero {

    uint public x;
    constructor() {
        x - 9;
    }
}
contract One is Zero {}
contract Two is Zero {}

contract Test is One, Two{
    modifier whenNotPaused() {_;}
    modifier auth() {_;}
    modifier onlyOwner() {_;}

    constructor() {
        a = 1;
        b = 2;
        c = 3;
    }

    uint public a;
    uint public b;
    uint public c;
    function test() public view whenNotPaused returns (uint256) {
        return a;
    }
    function test2(uint a_) public pure auth returns (uint256) {
        return a_;
    }
    function test3(uint b_) public onlyOwner returns (uint256) {
        b = b_;
        c - 2 * b_;
        return b_ * 8;

    }
    function test4() public view returns (uint256) {
        return a + b + c;
    }
}