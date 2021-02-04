pragma experimental ABIEncoderV2;

import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {ECDSA} from '@openzeppelin/contracts/cryptography/ECDSA.sol';
import {SafeMath} from '@openzeppelin/contracts/math/SafeMath.sol';

import './OracleClient.sol';

contract NFTFactory is ERC721 {

	using ECDSA for bytes32;
	using SafeMath for uint;

	struct Land {
		uint id;
		uint price;
		bytes agreement;
		uint period;
	}

	struct Bio {
		uint id;
		uint redeemablePrice;
		address toBeOwner;
		bytes hashedLocation;
	}

	event Reveal(address indexed owner, string indexed tokenKey);

	mapping(uint => Land) public landIndexes;
	mapping(uint => Bio) public bioIndexes;
	mapping(uint => address) public tokenHolderByIndex;

    OracleClient public oracleClient;

	constructor(address oracleClientAddress) ERC721("Gov10", "GOV10") public {
		// set rate cap dynamically
        oracleClient = OracleClient(address(oracleClientAddress));
	}

    // function 
    function issueNFTCommitment(address owner, uint depositAmount, uint weeksAfter, bytes memory dataHash, string memory tokenUri) public {
    	// bio NFT to delegator, and land to 
    	uint tokenId = super.totalSupply();
    	uint tokenIdLand = tokenId + 1;

    	// temp
    	uint price = depositAmount;

    	// cap on price ownership
    	// require(cap <= 0.5)

    	// creates the bio nft
    	Bio memory bio = Bio(tokenId, price, owner, dataHash);
    	// Bio memory bio = Bio(tokenId, price.mul(2).div(10), owner, dataHash);
    	bioIndexes[tokenId] = bio;

    	Land memory land = Land(tokenId, price, dataHash, weeksAfter);
    	landIndexes[tokenIdLand] = land;

    	tokenHolderByIndex[tokenId] = owner;
    	tokenHolderByIndex[tokenIdLand] = owner;

    	// 
    	// super.approve(address(this), tokenId);

    	// mints the bio
		super._safeMint(owner, tokenId, dataHash);
		// wait to seet tokenuri

		// mints the land
		super._safeMint(owner, tokenIdLand);
		super._setTokenURI(tokenIdLand, tokenUri);

		// _tokenIds++;

    }

    // function reveal(address owner, uint tokenId, string memory tokenKey, bytes memory signature, address buyer) public view returns (uint) {
    function reveal(address owner, uint tokenId, string memory tokenKey, bytes memory _signature, address buyer) public view returns (address) {
		// get hash,
		// unpack & see that it equals
		// check to ensure key
		// emit in an event
		// emit Reveal(owner, tokenKey);

		bytes32 message = keccak256(abi.encodePacked(owner));
   		bytes32 preFixedMessage = message.toEthSignedMessageHash();
    
    	// Confirm the signature came from the owner, same as web3.eth.sign(...)
    	// require(owner == preFixedMessage.recover(signature));
    	// return preFixedMessage.recover(signature);
    	
    	return ECDSA.recover(preFixedMessage, _signature);

		// return oracleClient.getMultiplierEstimate();


    	// set nft URI

    	// super._setTokenURI(tokenId, tokenKey);
    	// super.approve(buyer, tokenId);

		// makeTransfer
		// return funds back to owner

	}

	function redeem(uint tokenId, bytes memory _dataKey) public {
		// TODO: transfer Bio NFT to land owner
		require(bioIndexes[tokenId].toBeOwner == msg.sender, "msg.sender must match toBeOwner");

    	super.transferFrom(tokenHolderByIndex[tokenId], msg.sender, tokenId);

		// Claim and record the nonce
    	// require(super.claim(_tokenURI, _sig, address(this)), "Signature is invalid");
	}
}