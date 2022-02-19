// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.8.0;
// coz of sol < 0.8.0
pragma experimental ABIEncoderV2;

import "https://github.com/rarible/protocol-contracts/blob/958064138538215fa8fa654ea7148621f7ce53a1/lazy-mint/contracts/erc-721/LibERC721LazyMint.sol";

interface ERC721RaribleInterface {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _approved, uint256 _tokenId) external payable;
    function getApproved(uint256 tokenId) external view returns (address);

    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
    function mintAndTransfer(LibERC721LazyMint.Mint721Data memory data, address to) external;
}
    // struct Mint721Data {
    //     uint tokenId;
    //     string tokenURI;
    //     LibPart.Part[] creators;
    //     LibPart.Part[] royalties;
    //     bytes[] signatures;
    // }

    //     struct Part {
    //     address payable account;
    //     uint96 value;
    // }
