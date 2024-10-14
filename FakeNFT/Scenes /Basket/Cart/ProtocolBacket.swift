//
//  ProtocolBacket.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import Foundation

protocol BacketViewProtocol: AnyObject {
    func updateNFTCountLabel(with count: Int)
    func updateTotalPriceLabel(with totalPrice: Double)
    func payButtonTapped()
}
