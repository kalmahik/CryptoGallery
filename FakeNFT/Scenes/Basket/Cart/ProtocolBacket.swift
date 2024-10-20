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
}

protocol BacketPresenterProtocol {
    func loadNFTData()
    func saveSortOption(_ option: SortOption)
    func sortNFTItems(by option: SortOption)
    func getNFTItemsCount() -> Int
    func getNFTItem(at index: Int) -> NFT
    func payButtonTapped()
    func deleteNFT(at index: Int)
}
