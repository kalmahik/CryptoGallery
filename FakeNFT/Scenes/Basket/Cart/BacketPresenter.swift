//
//  BacketPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class BacketPresenter: BacketPresenterProtocol {

    // MARK: - Private Properties

    private weak var view: BacketViewProtocol?

    private var nftItems: [NFT] = []
    private var sortManager = SortManager()

    // MARK: - Initialization

    init(view: BacketViewProtocol) {
        self.view = view
        self.nftItems = MockData.nftItems
    }

    // MARK: - Public Methods

    func loadNFTData() {
        view?.updateNFTCountLabel(with: nftItems.count)
        let totalPrice = nftItems.reduce(0) { $0 + $1.price }
        view?.updateTotalPriceLabel(with: totalPrice)
        let selectedSortOption = sortManager.loadSortOption()
        sortNFTItems(by: selectedSortOption)
    }

    func saveSortOption(_ option: SortOption) {
        sortManager.saveSortOption(option)
    }

    func sortNFTItems(by option: SortOption) {
        switch option {
        case .price:
            nftItems.sort { $0.price < $1.price }
        case .rating:
            nftItems.sort { $0.rating > $1.rating }
        case .name:
            nftItems.sort { $0.name < $1.name }
        }
        view?.updateNFTCountLabel(with: nftItems.count)
        let totalPrice = nftItems.reduce(0) { $0 + $1.price }
        view?.updateTotalPriceLabel(with: totalPrice)
    }

    func getNFTItemsCount() -> Int {
        return nftItems.count
    }

    func getNFTItem(at index: Int) -> NFT {
        return nftItems[index]
    }

    func payButtonTapped() {
        guard let viewController = view as? UIViewController else { return }
        let paymentVC = PaymentMethodViewController()
        paymentVC.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(paymentVC, animated: true)
    }

    func deleteNFT(at index: Int) {
        guard index < nftItems.count else { return }
        nftItems.remove(at: index)
        view?.updateNFTCountLabel(with: nftItems.count)
        let totalPrice = nftItems.reduce(0) { $0 + $1.price }
        view?.updateTotalPriceLabel(with: totalPrice)
    }
}
