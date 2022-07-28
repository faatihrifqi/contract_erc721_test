// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721_Price is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public constant MAX_TOKENS = 10_000;
    uint256 public constant MAX_TOKENS_PER_ADDRESS = 100;

    uint256 public constant PRICE = 0.05 ether;

    string private mBaseURI;
    string private mRevealedBaseURI;

    constructor() ERC721("Test", "TST") {}

    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function mint(uint256 amount) external payable {
        require(
            balanceOf(msg.sender) + amount <= MAX_TOKENS_PER_ADDRESS,
            "Your max token holding exceeded"
        );
        require(
            _tokenIdCounter.current() + amount <= MAX_TOKENS,
            "Max token supply exceeded"
        );
        require(msg.value >= amount * PRICE, "Insufficient funds");

        for (uint256 i; i < amount; ) {
            _safeMint(msg.sender, _tokenIdCounter.current());
            _tokenIdCounter.increment();

            unchecked {
                ++i;
            }
        }
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setBaseURI(string calldata URI) external onlyOwner {
        mBaseURI = URI;
    }

    function setRevealedBaseURI(string calldata URI) external onlyOwner {
        mRevealedBaseURI = URI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "Token does not exist");

        string memory revealedBaseURI = mRevealedBaseURI;
        return
            bytes(revealedBaseURI).length > 0
                ? string(abi.encodePacked(revealedBaseURI, tokenId.toString()))
                : mBaseURI;
    }
}
