pragma solidity >=0.4.22;

import './Document.sol';

contract DocumentFactory{
    
    mapping(address => Document[]) public addressToDocuments;
    
    function createDocument(string memory ipfs, string memory name, string memory desc, string memory ownerName) public returns(Document){
        Document newDocument = new Document(name, desc, ipfs, msg.sender, ownerName);
        addressToDocuments[msg.sender].push(newDocument);

        return newDocument;
    }
    
    function getDocuments(address account) public view returns(Document[] memory) {
        return addressToDocuments[account];
    }
    
    function giveDocumentAccess(string memory signer_name, address account, Document doc) public {
        addressToDocuments[account].push(doc);
        doc.allowToSign(signer_name, account, msg.sender);
    }
}