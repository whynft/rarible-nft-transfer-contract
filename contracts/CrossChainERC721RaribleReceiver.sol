// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.8.0;
pragma experimental ABIEncoderV2;

import "https://github.com/rarible/protocol-contracts/blob/958064138538215fa8fa654ea7148621f7ce53a1/lazy-mint/contracts/erc-721/LibERC721LazyMint.sol";
import "./ERC721RaribleInterface.sol";

contract CrossChainERC721RaribleReceiver {
    function receiveCrossChainTransfer(address nftContract,
        address nftOwner, LibERC721LazyMint.Mint721Data memory data, bytes memory toChainCreatorSignature) external {

        ERC721RaribleInterface erc721Interface;
        erc721Interface = ERC721RaribleInterface(nftContract);
        require(data.creators.length == 1); // for now transfer nft only with one creator
        data.signatures[0] = toChainCreatorSignature;
        erc721Interface.mintAndTransfer(data, nftOwner);
    }
}

