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

    private var nftItems: [NFTResponse] = []
    private var sortManager = SortManager()
    private var orderService: OrderService

    // MARK: - Initialization

    init(view: BacketViewProtocol, orderService: OrderService = OrderService()) {
        self.view = view
        self.orderService = orderService
    }

    // MARK: - Public Methods

    func loadNFTData() {
        (view as? BacketViewController)?.showLoadingIndicator()
        orderService.fetchOrderAndNFTs { [weak self] result in
            (self?.view as? BacketViewController)?.hideLoadingIndicator()
            switch result {
            case .success(let nftResponses):
                self?.nftItems = nftResponses
                let selectedSortOption = self?.sortManager.loadSortOption() ?? .name
                self?.sortNFTItems(by: selectedSortOption)
                self?.updateViewWithNFTData()
            case .failure(let error):
                print("Ошибка загрузки NFT: \(error)")
            }
        }
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
        updateViewWithNFTData()
    }

    func getNFTItemsCount() -> Int {
        return nftItems.count
    }

    func getNFTItem(at index: Int) -> NFTResponse {
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
        updateViewWithNFTData()
    }

    // MARK: - Private Methods

    private func updateViewWithNFTData() {
        view?.updateNFTCountLabel(with: nftItems.count)
        let totalPrice = nftItems.reduce(0) { $0 + $1.price }
        view?.updateTotalPriceLabel(with: totalPrice)
        view?.reloadTableViewData()
    }
}
