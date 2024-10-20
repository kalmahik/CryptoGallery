//
//  TableViewCellPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class NFTCellPresenter: NFTCellPresenterProtocol {

    // MARK: - Private Properties

    private weak var view: NFTCellViewProtocol?

    private var nft: NFT

    // MARK: - Initializers

    init(view: NFTCellViewProtocol, nft: NFT) {
        self.view = view
        self.nft = nft
    }

    // MARK: - Public Methods

    func loadNFTData() {
        view?.displayNFTName(nft.name)
        view?.displayNFTRating(nft.rating)
        view?.displayNFTPrice(nft.price)
        view?.displayNFTImage(UIImage(named: nft.image.first ?? ""))
    }

    func deleteNFT(from viewController: UIViewController, at index: Int) {
        let deleteConfirmationVC = DeleteConfirmationViewController()
        deleteConfirmationVC.nftImage = UIImage(named: nft.image.first ?? "")
        deleteConfirmationVC.onDeleteConfirmed = {
            if let backetVC = viewController as? BacketViewController {
                backetVC.deleteNFT(at: index)
            }
        }
        deleteConfirmationVC.modalPresentationStyle = .overFullScreen
        deleteConfirmationVC.modalTransitionStyle = .crossDissolve
        viewController.present(deleteConfirmationVC, animated: true, completion: nil)
    }
}
