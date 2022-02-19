// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.8.0;
pragma experimental ABIEncoderV2;

import "./ERC721RaribleInterface.sol";

/**
* @title Cross Chain Transfer for an NFT.
* @dev 1. Sender apporves nft for the contract.
* @dev 2. Sender init tryCrossChainTransfer ->
* @dev oracle gets event and init nft creation
* @dev for the same owner in different ethereum friendly chain.
* @dev The NFT collection (i.e. erc721 contract) ought to exist in the desired network.
* @dev Thus, erc721 contract deployer ought to deploy the same contract in desired chain.
* @dev For now it is kinda more about Rarible erc721 Cross Chain Transfer
*/
contract CrossChainERC721RaribleTransfer {

    /// @dev Emit event is for our oracles
    /// @dev todo: add argument to specify what contract emits: e.g. Rarible or OpenSea erc721, etc
    event TryCrossChainTransfer(uint256 toChain, address indexed nftContract, uint256 nftToken,
        address nftOwner, string nftURI, LibPart.Part[] raribleRoyalties, string memory toChainMintSignature);

    function tryCrossChainTransfer(uint256 _toChainId, address _nftContract, uint256 _nftToken, string memory _toChainMintSignature) external {
        // todo: payable to pay minting in other chain. We want our contract "service" to be profitable.
        // todo: check if nft has desired method (mintAndTransfer) in the desired chain. (oracles should check it)
        // todo: check if getRaribleV2Royalties, tokenURI
        // todo: idempotent logic: user can retry this method, but nft owner changed coz of success transfer
        // so, we should possible have mapping in contract, but rather this such a business logic could be
        // implemented in oracles instead, thus, we leave contract as light as possible.
        Erc721RaribleInterface erc721Interface;
        erc721Interface = Erc721RaribleInterface(_nftContract);

        require(erc721Interface.getApproved(_nftToken) == address(this), "Erc721 token is not approved for current contract");
        address _nftOwner = erc721Interface.ownerOf(_nftToken);
        string memory _nftURI = erc721Interface.tokenURI(_nftToken);
        LibPart.Part[] memory _raribleRoyalties = erc721Interface.getRaribleV2Royalties(_nftToken);
        if (_nftOwner != address(this)) {
            erc721Interface.transferFrom(_nftOwner, address(this), _nftToken);
            // todo: on else emit another event to init retry action (why: check above comments)
        }
        emit TryCrossChainTransfer(_toChainId, _nftContract, _nftToken, _nftOwner, _nftURI, _raribleRoyalties, _toChainMintSignature);
    }
}

