//
//  ProtocolBacket.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import Foundation

protocol BacketViewProtocol: AnyObject {
    func updateNFTCountLabel(with count: Int)
    func updateTotalPriceLabel(with totalPrice: Float)
    func payButtonTapped()
    func reloadTableViewData()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

protocol BacketPresenterProtocol {
    func loadNFTData()
    func saveSortOption(_ option: SortOption)
    func sortNFTItems(by option: SortOption)
    func getNFTItemsCount() -> Int
    func getNFTItem(at index: Int) -> NFTResponse
    func payButtonTapped()
    func deleteNFT(at index: Int)
}