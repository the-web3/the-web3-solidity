// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract AssemblyTest {
    function add(uint256 a, uint256 b) public view returns (uint256)  {
        uint256 result;
        assembly {
          result := add(a, b)
        }
        return result;
    }

    function sub(uint256 a, uint256 b) public view returns (uint256) {
        uint256 result;
        assembly {
            result := sub(a, b)
        }
        return result;
    }

    function mul(uint256 a, uint256 b) public view returns (uint256) {
        uint256 result;
        assembly {
            result := mul(a, b)
        }
        return result;
    }

    function div(uint256 a, uint256 b) public view returns (uint256) {
        uint256 result;
        assembly {
            result := div(a, b)
        }
        return result;
    }
}
