//
//  BasketMockData.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import Foundation

struct MockData {
    static let nftItems: [NFT] = [
        NFT(name: "April", rating: 1, price: "1.78 ETH", imageName: "mock1"),
        NFT(name: "Greena", rating: 3, price: "1.78 ETH", imageName: "mock2"),
        NFT(name: "Spring", rating: 5, price: "1.78 ETH", imageName: "mock3")
    ]
}
