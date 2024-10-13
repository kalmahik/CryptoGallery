//
//  TableViewCellPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class NFTCellPresenter {

    private weak var view: NFTCellView?
    private var nft: NFT

    init(view: NFTCellView, nft: NFT) {
        self.view = view
        self.nft = nft
    }

    func loadNFTData() {
        view?.displayNFTName(nft.name)
        view?.displayNFTRating(nft.rating)
        view?.displayNFTPrice(nft.price)
        view?.displayNFTImage(UIImage(named: nft.imageName))
    }

    func deleteNFT() {
        print("NFT удалено")
    }
}
