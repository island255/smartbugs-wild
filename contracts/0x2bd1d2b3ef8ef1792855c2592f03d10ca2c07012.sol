{"KonradToken.sol":{"content":"pragma solidity ^0.5.0;\r\n\r\nimport \"./SafeMath.sol\";\r\n\r\ncontract KonradToken {\r\n\r\n\tusing SafeMath for uint256;\r\n\r\n// Public variables of the token\r\nuint32 public decimals = 18;\r\nstring public name = \"Konrad Token\";\r\nstring public symbol = \"KDX\";\r\nuint256 public totalSupply= 1000000000 *(10**uint256(decimals)); \r\n\r\nmapping(address =\u003e uint256) public balanceOf;\r\nmapping(address =\u003e mapping(address =\u003e uint256)) public allowance;\r\n\r\naddress admin;\r\nbool transferPaused = true;\r\nmapping(address =\u003e bool) public blacklist;\r\nmapping(address =\u003e bool) public whitelist;\r\n\r\nevent Transfer(address indexed from, address indexed to, uint256 value);\r\nevent Burn(address indexed from, uint256 value);\r\nevent Approval(address indexed _owner, address indexed _spender, uint256 value);\r\n\r\n\r\nconstructor() public {\r\n\tbalanceOf[msg.sender] = totalSupply;\r\n\tadmin = msg.sender;\r\n\temit Transfer(address(0),msg.sender,totalSupply);\r\n}\r\n\r\n  /**\r\n  * @dev transfer token for a specified address\r\n  * @param _to The address to transfer to.\r\n  * @param _value The amount to be transferred.\r\n  */\r\n\r\n  function transfer(address _to, uint256 _value) transferable public returns (bool){\r\n\r\n  \trequire(_to != address(0));\r\n  \trequire(_value \u003c= balanceOf[msg.sender]);\r\n  \tbalanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\r\n  \tbalanceOf[_to] = balanceOf[_to].add(_value);\r\n  \temit Transfer(msg.sender, _to, _value);\r\n  \treturn true;\r\n  }\r\n\r\n\r\n/**\r\n* Transfer tokens from other address\r\n*\r\n* Send `_value` tokens to `_to` on behalf of `_from`\r\n*\r\n* @param _from The address of the sender\r\n* @param _to The address of the recipient\r\n* @param _value the amount to send\r\n*/\r\n\r\nfunction transferFrom(address _from, address _to, uint256 _value) transferable public returns (bool) {\r\n\t\r\n\r\n\trequire(_value \u003c= allowance[_from][msg.sender]);\r\n\tallowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\r\n\tbalanceOf[_from] = balanceOf[_from].sub(_value);\r\n\tbalanceOf[_to] = balanceOf[_to].add(_value);\r\n\temit Transfer(_from, _to, _value);\r\n\treturn true;\r\n}\r\n\r\n/**\r\n* Set allowance for other address\r\n*\r\n* Allows `_spender` to spend no more than `_value` tokens on your behalf\r\n*\r\n* @param _spender The address authorized to spend\r\n* @param _value the max amount they can spend\r\n6\r\n*/\r\nfunction approve(address _spender, uint256 _value) public returns (bool) {\r\n\trequire(!blacklist[_spender] \u0026\u0026 !blacklist[msg.sender]);\r\n\tallowance[msg.sender][_spender] = _value;\r\n\temit Approval(msg.sender, _spender, _value);\r\n\treturn true;\r\n\r\n}\r\n\r\nfunction burn(uint256 _value) public returns (bool) {\r\n\trequire(!blacklist[msg.sender]);\r\n\trequire(balanceOf[msg.sender] \u003e= _value);\r\n\tbalanceOf[msg.sender] =balanceOf[msg.sender].sub(_value);\r\n\ttotalSupply = totalSupply.sub(_value);\r\n\temit Burn(msg.sender, _value);\r\n\treturn true;\r\n}\r\n\r\n\r\n/**\r\n* Ban address\r\n*\r\n* @param addr ban addr\r\n*/\r\nfunction addToBlacklist(address addr) public {\r\n\trequire(msg.sender == admin);\r\n\tblacklist[addr] = true;\r\n}\r\n/**\r\n* Enable address\r\n*\r\n* @param addr enable addr\r\n*/\r\nfunction removeFromBlacklist(address addr) public {\r\n\trequire(msg.sender == admin);\r\n\tblacklist[addr] = false;\r\n}\r\n\r\nfunction addToWhitelist(address addr) public {\r\n\trequire(msg.sender == admin);\r\n\twhitelist[addr] = true;\r\n}\r\nfunction removeFromWhitelist(address addr) public {\r\n\trequire(msg.sender == admin);\r\n\twhitelist[addr] = false;\r\n}\r\n\r\n\r\n// The modifier checks if the address can send tokens \r\nmodifier transferable(){\r\n\trequire(!transferPaused || whitelist[msg.sender] || msg.sender == admin);\r\n\trequire(!blacklist[msg.sender]);\r\n\t_;\r\n}\r\n\r\n// Unpause token transfer\r\nfunction unpauseTransfer() public {\r\n\trequire(msg.sender == admin);\r\n\ttransferPaused = false;\r\n}\r\n\r\n// transfer ownership of the contract\r\nfunction transferOwnership(address newOwner) public {\r\n\trequire(msg.sender == admin);\r\n\tadmin = newOwner;\r\n} \r\n\r\n}"},"SafeMath.sol":{"content":"pragma solidity ^0.5.0;\n\n/**\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow\n * checks.\n *\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\n * in bugs, because programmers usually assume that an overflow raises an\n * error, which is the standard behavior in high level programming languages.\n * `SafeMath` restores this intuition by reverting the transaction when an\n * operation overflows.\n *\n * Using this library instead of the unchecked operations eliminates an entire\n * class of bugs, so it\u0027s recommended to use it always.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity\u0027s `+` operator.\n     *\n     * Requirements:\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c \u003e= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity\u0027s `-` operator.\n     *\n     * Requirements:\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        require(b \u003c= a, \"SafeMath: subtraction overflow\");\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity\u0027s `*` operator.\n     *\n     * Requirements:\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\n        // benefit is lost if \u0027b\u0027 is also tested.\n        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers. Reverts on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Solidity only automatically asserts when dividing by 0\n        require(b \u003e 0, \"SafeMath: division by zero\");\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * Reverts when dividing by zero.\n     *\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        require(b != 0, \"SafeMath: modulo by zero\");\n        return a % b;\n    }\n}\n"}}