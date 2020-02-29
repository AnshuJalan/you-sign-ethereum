pragma solidity >= 0.4.22;

contract Document {
    
    address public owner;
    
    string public name;
    string public description;

    address[] public signers;
    
    mapping(address => bool) public addressToAllowed;
    mapping(address => string) public addressToString;
    mapping(address => uint) public addressToTimeSigned;
    mapping(address => bool) public addressToSigned;
    
    string public ipfs_hash; 
    
    uint public timestamp;
    uint public left;
    
    //Events
    event signed(address signer);
    
    constructor(string memory na, string memory desc, string memory ipfs, address creator, string memory ownerName) public {
        owner = creator;
        name = na;
        description = desc;

        signers.push(owner);
        left++;
        addressToAllowed[creator] = true;
        addressToString[creator] = ownerName;
        
        ipfs_hash = ipfs;
        
        timestamp = block.timestamp;
    }
    
    //Sign logic
    function sign() external payable isSigner(msg.sender) {
        uint sentAmt = msg.value;
        
        addressToSigned[msg.sender] = true;
        addressToTimeSigned[msg.sender] = block.timestamp;
        
        left--;
        
        //Return amount
        (msg.sender).transfer(sentAmt);
        
        //Emit sign event
        emit signed(msg.sender);
    }
    
    //Add recipient
    function allowToSign(string memory signer_name, address signer, address sender) public {
        require(sender == owner, "You are not the owner of the document.");
        require(addressToAllowed[signer] != true, "Already allowed to sign.");
        
        signers.push(signer);
        left++;
        
        addressToAllowed[signer] = true;
        addressToString[signer] = signer_name;
    }
    
    //No. of signers
    function getSignersCount() public view returns(uint){
        return signers.length;
    }
    
    function checkValidity(string memory hash) public view returns(bool){
        if(keccak256(bytes(hash)) == keccak256(bytes(ipfs_hash)))
            return true;
        else
            return false;
    }
    
    modifier isSigner(address sender){
        require(addressToAllowed[sender] == true, "Sorry, you do not have permission to sign this document.");
        require(addressToSigned[sender] != true, "You have already signed the document.");
        _;
    }
}