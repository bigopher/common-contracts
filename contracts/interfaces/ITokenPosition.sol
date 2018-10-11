pragma solidity ^0.4.24;

contract ITokenPosition {

    uint256 constant CLEAR_LOW = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
    uint256 constant CLEAR_HIGH = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    uint256 constant FACTOR = 0x100000000000000000000000000000000;

    // virtual api
    function getTokenLocation(uint _tokenId) public view returns (int, int);

    function encodePositionId(int _x, int _y) public pure  returns (uint result) {
        return _encodePositionId(_x, _y);
    }

    function _encodePositionId(int _x, int _y) internal pure  returns (uint result) {
        return _unsafeEncodeTokenId(_x, _y);
    }
    function _unsafeEncodeTokenId(int _x, int _y) internal pure  returns (uint) {
        return ((uint(_x) * FACTOR) & CLEAR_LOW) | (uint(_y) & CLEAR_HIGH) + 1;
    }

    function decodePositionId(uint _positionId) public pure  returns (int, int) {
        return _decodePositionId(_positionId);
    }
    function _decodePositionId(uint _positionId) internal pure  returns (int x, int y) {
        (x, y) = _unsafeDecodePositionId(_positionId);
    }

    function _unsafeDecodePositionId(uint _value) internal pure  returns (int x, int y) {
        require(_value > 0, "Position Id is start from 1, should larger than zero");
        x = expandNegative128BitCast(((_value - 1) & CLEAR_LOW) >> 128);
        y = expandNegative128BitCast((_value - 1) & CLEAR_HIGH);
    }

    function expandNegative128BitCast(uint _value) internal pure  returns (int) {
        if (_value & (1<<127) != 0) {
            return int(_value | CLEAR_LOW);
        }
        return int(_value);
    }

}