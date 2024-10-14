//
//  BacketPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class BacketPresenter {

    // MARK: - Private Properties

    private weak var view: BacketViewProtocol?
    private var nftItems: [NFT] = []

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
        viewController.navigationController?.pushViewController(paymentVC, animated: true)
    }
}
