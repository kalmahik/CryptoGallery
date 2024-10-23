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
    private let logger = Logger.shared

    // MARK: - Initializers

    init(view: NFTCellViewProtocol, nft: NFTResponse) {
        self.view = view
        self.nft = nft
    }

    // MARK: - Public Methods

    func loadNFTData() {
        logger.info("Загрузка данных для NFT с именем \(nft.name) и рейтингом \(nft.rating)")
        view?.displayNFTName(nft.name)
        view?.displayNFTRating(nft.rating)
        view?.displayNFTPrice(nft.price)
        if let imageUrlString = nft.images.first, let imageUrl = URL(string: imageUrlString) {
            logger.debug("Начата загрузка изображения NFT с URL: \(imageUrlString)")
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let error = error {
                    self.logger.error("Ошибка загрузки изображения для NFT \(self.nft.name): \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.logger.info("Изображение NFT успешно загружено и отображено")
                        self.view?.displayNFTImage(image)
                    }
                } else {
                    self.logger.warning("Не удалось преобразовать данные в изображение для NFT \(self.nft.name)")
                }
            }.resume()
        } else {
            logger.warning("Отсутствует URL изображения для NFT \(nft.name)")
        }
    }

    func deleteNFT(from viewController: UIViewController, at index: Int) {
        logger.info("Попытка удаления NFT \(nft.name) с индекса \(index)")
        let deleteConfirmationVC = DeleteConfirmationViewController()
        guard let imageUrlString = nft.images.first, let imageUrl = URL(string: imageUrlString) else {
            logger.warning("Отсутствует URL изображения для подтверждения удаления NFT \(nft.name)")
            return
        }
        logger.debug("Загрузка изображения для подтверждения удаления NFT с URL: \(imageUrlString)")
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let error = error {
                self.logger.error("Ошибка загрузки изображения для подтверждения удаления: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                self.logger.warning("Не удалось преобразовать данные в изображение для подтверждения удаления")
                return
            }
            DispatchQueue.main.async {
                self.logger.info("Изображение для подтверждения удаления успешно загружено")
                deleteConfirmationVC.nftImage = image
                deleteConfirmationVC.onDeleteConfirmed = {
                    self.logger.info("Удаление NFT \(self.nft.name) подтверждено")

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
