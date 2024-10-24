//
//  BasketModels.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

struct OrderResponse: Codable {
    let nfts: [String]
    let id: String
}

struct NFTResponse: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}

struct Currency {
    let logo: UIImage?
    let fullName: String
    let shortName: String
}
