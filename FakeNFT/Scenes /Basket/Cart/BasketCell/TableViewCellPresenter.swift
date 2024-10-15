//
//  TableViewCellPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class NFTCellPresenter {

    // MARK: - Private Properties

    private weak var view: NFTCellView?
    private var nft: NFT

    // MARK: - Initializers

    init(view: NFTCellView, nft: NFT) {
        self.view = view
        self.nft = nft
    }

    // MARK: - Public Methods

    func loadNFTData() {
        view?.displayNFTName(nft.name)
        view?.displayNFTRating(nft.rating)
        view?.displayNFTPrice(nft.price)
        view?.displayNFTImage(UIImage(named: nft.imageName))
    }

    func deleteNFT(from viewController: UIViewController, at index: Int) {
        let deleteConfirmationVC = DeleteConfirmationViewController()
        deleteConfirmationVC.nftImage = UIImage(named: nft.imageName)
        deleteConfirmationVC.onDeleteConfirmed = {
            if let backetVC = viewController as? BacketViewController {
                backetVC.presenter?.deleteNFT(at: index)
                backetVC.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
        deleteConfirmationVC.modalPresentationStyle = .overFullScreen
        deleteConfirmationVC.modalTransitionStyle = .crossDissolve
        viewController.present(deleteConfirmationVC, animated: true, completion: nil)
    }
}
