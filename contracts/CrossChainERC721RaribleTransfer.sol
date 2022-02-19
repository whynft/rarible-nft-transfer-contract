// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.8.0;
pragma experimental ABIEncoderV2;

import "./ERC721RaribleInterface.sol";

contract CrossChainERC721RaribleTransfer {
    event TryCrossChainTransfer(uint256 toChain, address indexed nftContract, uint256 nftToken, address nftOwner, string nftURI, LibPart.Part[] raribleRoyalties);

    function tryCrossChainTransfer(uint256 _toChainId, address _nftContract, uint256 _nftToken) external {
        ERC721RaribleInterface erc721Interface;
        erc721Interface = ERC721RaribleInterface(_nftContract);

        require(erc721Interface.getApproved(_nftToken) == address(this), "Erc721 token is not approved for current contract");
        address _nftOwner = erc721Interface.ownerOf(_nftToken);
        string memory _nftURI = erc721Interface.tokenURI(_nftToken);
        LibPart.Part[] memory _raribleRoyalties = erc721Interface.getRaribleV2Royalties(_nftToken);
        if (_nftOwner != address(this)) {
            erc721Interface.transferFrom(_nftOwner, address(this), _nftToken);
        }
        emit TryCrossChainTransfer(_toChainId, _nftContract, _nftToken, _nftOwner, _nftURI, _raribleRoyalties);
    }
}
