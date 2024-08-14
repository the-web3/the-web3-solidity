// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/*
 * if
 * for, whlie, do-while
 */
contract LoopBranch {
    uint256 public number;
    uint256[] public numberList;

    constructor(){
    }

    error MustLessThan100Err(uint256 number);

    event LogError(string message, uint256 number);

    function setNumber(uint256 _number) external {
        require(_number > 1, "number must more than one");
        if(_number > 100) {
            revert("number must less than 100");
        } else if (_number == 10) {
          revert MustLessThan100Err(_number);
        } else if (_number == 5){
            emit LogError("number must not equal five", _number);
        } else {
            number =  number;
        }
    }

    function addNumberList(uint256 _count) external {
        for(uint256 index = 0; index < _count; index++) {
            numberList.push(index);
        }
    }

    function getNumberList() external view returns(uint256[] memory) {
        return numberList;
    }

    function numberIncresement() external {
        while(number < 100) {
            number++;
        }
    }

    function numberIncresementDoWhile() external {
        do {
            number++;
        }while(number < 100);
    }
}
