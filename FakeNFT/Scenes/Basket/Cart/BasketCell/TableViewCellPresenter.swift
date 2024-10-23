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

    private var nft: NFTResponse

    // MARK: - Initializers

    init(view: NFTCellViewProtocol, nft: NFTResponse) {
        self.view = view
        self.nft = nft
    }

    // MARK: - Public Methods

    func loadNFTData() {
        view?.displayNFTName(nft.name)
        view?.displayNFTRating(nft.rating)
        view?.displayNFTPrice(nft.price)
        if let imageUrlString = nft.images.first, let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.view?.displayNFTImage(image)
                    }
                }
            }.resume()
        }
    }

    func deleteNFT(from viewController: UIViewController, at index: Int) {
        let deleteConfirmationVC = DeleteConfirmationViewController()
        guard let imageUrlString = nft.images.first, let imageUrl = URL(string: imageUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                deleteConfirmationVC.nftImage = image
                deleteConfirmationVC.onDeleteConfirmed = {
                    if let backetVC = viewController as? BacketViewController {
                        backetVC.deleteNFT(at: index)
                    }
                }
                deleteConfirmationVC.modalPresentationStyle = .overFullScreen
                deleteConfirmationVC.modalTransitionStyle = .crossDissolve
                viewController.present(deleteConfirmationVC, animated: true, completion: nil)
            }
        }.resume()
    }
}
