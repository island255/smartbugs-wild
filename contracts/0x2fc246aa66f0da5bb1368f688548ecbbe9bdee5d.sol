{"ERC20.sol":{"content":"pragma solidity ^0.4.24;\r\n\r\n/**\r\n * @title ERC20 interface\r\n * @dev see https://github.com/ethereum/EIPs/issues/20\r\n */\r\ncontract ERC20 {\r\n    function allowance(address owner, address spender) public view returns (uint256);\r\n    function transferFrom(address from, address to, uint256 value) public returns (bool);\r\n    function approve(address spender, uint256 value) public returns (bool);\r\n    event Approval(address indexed owner, address indexed spender, uint256 value);\r\n    function totalSupply() public view returns (uint256);\r\n    function balanceOf(address who) public view returns (uint256);\r\n    function transfer(address to, uint256 value) public returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n}\r\n"},"Lockable.sol":{"content":"pragma solidity ^0.4.24;\r\n\r\n\r\nimport \"./Ownable.sol\";\r\n\r\n\r\n/**\r\n * @title Lockable\r\n * @dev lock up token transfer during duration. This helps lock up private and pre-sale investor cannot sell token certain period.\r\n * @author Geunil(Brian) Lee\r\n */\r\ncontract Lockable is Ownable {\r\n  \r\n    /**\r\n    * @dev hold lock up address and duration\r\n    */\r\n    mapping(address =\u003e uint256) public lockedUp;\r\n  \r\n    uint public nowTime;\r\n    \r\n    constructor () public {\r\n        nowTime = now;        \r\n    }\r\n\r\n    /**\r\n    * @dev lock up by pass when duration is passed or not exist on lockedUp mapping.\r\n    */\r\n    modifier whenNotLockedUp() {\r\n        require(lockedUp[msg.sender] \u003c now || lockedUp[msg.sender] == 0 );\r\n        _;\r\n    }\r\n\r\n\r\n    /**\r\n    * @dev lock up status\r\n    * @return true - no lock up. false - locked up \r\n    */\r\n    function nolockedUp(address sender) public view returns (bool){\r\n        if(lockedUp[sender] \u003c now || lockedUp[sender] == 0){\r\n            return true; \r\n        }\r\n        return false;                \r\n    }\r\n  \r\n    /**\r\n    * @dev add lock up investor to mapping\r\n    * @param _investor lock up address\r\n    * @param _duration lock up period. unit is days\r\n    */\r\n    function addLockUp(address _investor, uint _duration ) onlyOwner public {\r\n        require(_investor != address(0) \u0026\u0026 _duration \u003e 0);\r\n        lockedUp[_investor] = now + _duration * 1 days; \r\n    }\r\n    \r\n    /**\r\n    * @dev remove lock up address from mapping\r\n    * @param _investor lock up address to be removed from mapping\r\n    */\r\n    function removeLockUp(address _investor ) onlyOwner public {\r\n        require(_investor != address(0));\r\n        delete lockedUp[_investor]; \r\n    }\r\n  \r\n  \r\n}"},"Ownable.sol":{"content":"pragma solidity ^0.4.24;\r\n\r\n\r\n/**\r\n * @title Ownable\r\n * @dev The Ownable contract has an owner address, and provides basic authorization control\r\n * functions, this simplifies the implementation of \"user permissions\".\r\n * based on https://https://github.com/OpenZeppelin/zeppelin-solidity. modified to have multiple ownership.\r\n * @author Geunil(Brian) Lee\r\n */\r\ncontract Ownable {\r\n  \r\n    /**\r\n    * Ownership can be owned by multiple owner. Useful when have multiple contract to communicate  each other\r\n    **/\r\n    mapping (address =\u003e bool) public owner;\r\n  \r\n    event OwnershipAdded(address newOwner);\r\n    event OwnershipRemoved(address noOwner);    \r\n\r\n    /**\r\n    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\r\n    * account.\r\n    */\r\n    constructor () public {\r\n        owner[msg.sender] = true;        \r\n    }\r\n\r\n    /**\r\n    * @dev Throws if called by any account other than the owner.\r\n    */\r\n    modifier onlyOwner() {\r\n        require(owner[msg.sender] == true);\r\n        _;\r\n    }\r\n\r\n    /**\r\n    * @dev Add ownership\r\n    * @param _newOwner add address to the ownership\r\n    */\r\n    function addOwnership(address _newOwner) public onlyOwner {\r\n        require(_newOwner != address(0));\r\n        owner[_newOwner] = true;\r\n        emit OwnershipAdded(_newOwner);\r\n    }\r\n  \r\n    /**\r\n    * @dev Remove ownership\r\n    * @param _ownership remove ownership\r\n    */\r\n    function removeOwner(address _ownership) public onlyOwner{\r\n        require(_ownership != address(0));\r\n        // owner cannot remove ownerhip itself\r\n        require(msg.sender != _ownership);\r\n        delete owner[_ownership];\r\n        emit OwnershipRemoved(_ownership);\r\n    }\r\n\r\n}"},"SafeMath.sol":{"content":"pragma solidity ^0.4.24;\r\n\r\n\r\n/**\r\n * @title SafeMath\r\n * @dev Math operations with safety checks that throw on error\r\n * based on https://https://github.com/OpenZeppelin/zeppelin-solidity.\r\n */\r\nlibrary SafeMath {\r\n\r\n    /**\r\n    * @dev Multiplies two numbers, throws on overflow.\r\n    */\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n        c = a * b;\r\n        assert(c / a == b);\r\n        return c;\r\n    }\r\n\r\n    /**\r\n    * @dev Integer division of two numbers, truncating the quotient.\r\n    */\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        // assert(b \u003e 0); // Solidity automatically throws when dividing by 0\r\n        // uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n        return a / b;\r\n    }\r\n\r\n    /**\r\n    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\r\n    */\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        assert(b \u003c= a);\r\n        return a - b;\r\n    }\r\n\r\n    /**\r\n    * @dev Adds two numbers, throws on overflow.\r\n    */\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\r\n        c = a + b;\r\n        assert(c \u003e= a);\r\n        return c;\r\n    }\r\n}"},"TemcoToken.sol":{"content":"pragma solidity ^0.4.24;\r\n\r\nimport \"./Ownable.sol\";\r\nimport \"./ERC20.sol\";\r\nimport \"./SafeMath.sol\";\r\nimport \"./Lockable.sol\";\r\n\r\n\r\n/**\r\n * @title TEMCO token\r\n * @dev Based on code by https://https://github.com/OpenZeppelin/zeppelin-solidity\r\n * @author Geunil(Brian) Lee\r\n */\r\ncontract TemcoToken is ERC20, Ownable, Lockable {\r\n  \r\n    using SafeMath for uint256;\r\n      \r\n    event OwnedValue(address owner, uint256 value);\r\n    event Mint(address to, uint256 amount);\r\n    event MintFinished();\r\n    event Burn(address burner, uint256 value);\r\n    \r\n    mapping(address =\u003e uint256) public balances;    \r\n    mapping (address =\u003e mapping (address =\u003e uint256)) internal allowed;\r\n\r\n    uint256 public totalSupply;\r\n    function totalSupply() public view returns (uint256) {\r\n        return totalSupply;\r\n    }\r\n  \r\n    // Public variables of the token\r\n    string public name;\r\n    string public symbol;\r\n    uint8 public decimals = 18;\r\n    \r\n    bool public mintingFinished = false;    \r\n    \r\n    /**\r\n    * Constructor function\r\n    *\r\n    * Initializes contract with initial supply tokens to the creator of the contract\r\n    */\r\n    constructor (\r\n        uint256 initialSupply,\r\n        string tokenName,\r\n        string tokenSymbol\r\n    )public {\r\n        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\r\n        emit OwnedValue(msg.sender, 0);\r\n        balances[msg.sender] = totalSupply;                // Give the creator all initial tokens\r\n        name = tokenName;                                   // Set the name for display purposes\r\n        symbol = tokenSymbol;                             // Set the symbol for display purposes\r\n    }\r\n      \r\n    /**\r\n    * @dev transfer token for a specified address\r\n    * @param _to The address to transfer to.\r\n    * @param _value The amount to be transferred.\r\n    */\r\n    function transfer(address _to, uint256 _value) public whenNotLockedUp returns (bool) {        \r\n        emit OwnedValue(msg.sender, _value);\r\n                \r\n        require(_to != address(0));\r\n        require(_to != address(this));\r\n        require(_value \u003c= balances[msg.sender]); \r\n\r\n        // SafeMath.sub will throw if there is not enough balance.\r\n        balances[msg.sender] = balances[msg.sender].sub(_value);\r\n        balances[_to] = balances[_to].add(_value);\r\n        emit Transfer(msg.sender, _to, _value);\r\n        return true;\r\n    }\r\n    \r\n    /**\r\n    * @dev Transfer tokens from one address to another\r\n    * @param _from address The address which you want to send tokens from\r\n    * @param _to address The address which you want to transfer to\r\n    * @param _value uint256 the amount of tokens to be transferred\r\n    */\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\r\n        require(_to != address(0));\r\n        require(_to != address(this));\r\n        require(_value \u003c= balances[_from]);\r\n        require(_value \u003c= allowed[_from][msg.sender]);\r\n        if(nolockedUp(_from) == false){\r\n            return false;\r\n        }\r\n        balances[_from] = balances[_from].sub(_value);\r\n        balances[_to] = balances[_to].add(_value);\r\n        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\r\n    *\r\n    * Beware that changing an allowance with this method brings the risk that someone may use both the old\r\n    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\r\n    * race condition is to first reduce the spender\u0027s allowance to 0 and set the desired value afterwards:\r\n    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\r\n    * @param _spender The address which will spend the funds.\r\n    * @param _value The amount of tokens to be spent.\r\n    */\r\n    function approve(address _spender, uint256 _value) public whenNotLockedUp returns (bool) {\r\n        allowed[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n  \r\n    /**\r\n    * @dev Gets the balance of the specified address.\r\n    * @param _owner The address to query the balance of.\r\n    * @return An uint256 representing the amount owned by the passed address.\r\n    */\r\n    function balanceOf(address _owner) public view returns (uint256 balance) {\r\n        return balances[_owner];\r\n    }\r\n\r\n    /**\r\n    * @dev Function to check the amount of tokens that an owner allowed to a spender.\r\n    * @param _owner address The address which owns the funds.\r\n    * @param _spender address The address which will spend the funds.\r\n    * @return A uint256 specifying the amount of tokens still available for the spender.\r\n    */\r\n    function allowance(address _owner, address _spender) public view returns (uint256) {\r\n        return allowed[_owner][_spender];\r\n    }\r\n\r\n    /**\r\n    * @dev Increase the amount of tokens that an owner allowed to a spender.\r\n    *\r\n    * approve should be called when allowed[_spender] == 0. To increment\r\n    * allowed value is better to use this function to avoid 2 calls (and wait until\r\n    * the first transaction is mined)\r\n    * From MonolithDAO Token.sol\r\n    * @param _spender The address which will spend the funds.\r\n    * @param _addedValue The amount of tokens to increase the allowance by.\r\n    */\r\n    function increaseApproval(address _spender, uint _addedValue) whenNotLockedUp public returns (bool) {\r\n        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\r\n        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n    * @dev Decrease the amount of tokens that an owner allowed to a spender.\r\n    *\r\n    * approve should be called when allowed[_spender] == 0. To decrement\r\n    * allowed value is better to use this function to avoid 2 calls (and wait until\r\n    * the first transaction is mined)\r\n    * From MonolithDAO Token.sol\r\n    * @param _spender The address which will spend the funds.\r\n    * @param _subtractedValue The amount of tokens to decrease the allowance by.\r\n    */\r\n    function decreaseApproval(address _spender, uint _subtractedValue) whenNotLockedUp public returns (bool) {\r\n        uint oldValue = allowed[msg.sender][_spender];\r\n        if (_subtractedValue \u003e oldValue) {\r\n            allowed[msg.sender][_spender] = 0;\r\n        } else {\r\n            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\r\n        }\r\n        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\r\n        return true;\r\n    }\r\n  \r\n    /**\r\n    * @dev Burns a specific amount of tokens.\r\n    * @param _value The amount of token to be burned.\r\n    */\r\n    function burn(uint256 _value) external onlyOwner {\r\n        require(_value \u003c= balances[msg.sender]);\r\n        // no need to require value \u003c= totalSupply, since that would imply the\r\n        // sender\u0027s balance is greater than the totalSupply, which *should* be an assertion failure\r\n\r\n        address burner = msg.sender;\r\n        balances[burner] = balances[burner].sub(_value);\r\n        totalSupply = totalSupply.sub(_value);\r\n        emit Burn(burner, _value);\r\n        emit Transfer(burner, address(0), _value);\r\n    }\r\n  \r\n    modifier canMint() {\r\n        require(!mintingFinished);\r\n        _;\r\n    }\r\n\r\n    /**\r\n    * @dev Function to mint tokens\r\n    * @param _to The address that will receive the minted tokens.\r\n    * @param _amount The amount of tokens to mint.\r\n    * @return A boolean that indicates if the operation was successful.\r\n    */\r\n    function mint(address _to, uint256 _amount) onlyOwner canMint external returns (bool) {\r\n        require(_to != address(0) \u0026\u0026 _amount \u003e 0);\r\n        totalSupply = totalSupply.add(_amount);\r\n        balances[_to] = balances[_to].add(_amount);\r\n        emit Mint(_to, _amount);\r\n        emit Transfer(address(0), _to, _amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n    * @dev Function to mint tokens\r\n    * @param _to The address that will receive the minted tokens.\r\n    * @param _amount The amount of tokens to mint.\r\n    * @return A boolean that indicates if the operation was successful.\r\n    */\r\n    function mintTo(address _from, address _to, uint256 _amount) onlyOwner canMint external returns (bool) {\r\n        require(_from != address(0)  \u0026\u0026 _to != address(0) \u0026\u0026 _amount \u003e 0);        \r\n        balances[_from] = balances[_from].sub(_amount);\r\n        balances[_to] = balances[_to].add(_amount);        \r\n        emit Mint(_to, _amount);\r\n        emit Transfer(address(0), _to, _amount);\r\n        return true;\r\n    }\r\n\r\n    /**\r\n    * @dev Function to stop minting new tokens.\r\n    * @return True if the operation was successful.\r\n    */\r\n    function finishMinting() onlyOwner canMint external returns (bool) {\r\n        mintingFinished = true;\r\n        emit MintFinished();\r\n        return true;\r\n    }\r\n  \r\n}\r\n"}}