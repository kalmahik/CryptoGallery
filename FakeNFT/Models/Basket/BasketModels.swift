//
//  BasketModels.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

struct NFT {
    let name: String
    let rating: Int
    let price: Float
    let image: [String]
}

struct Currency {
    let logo: UIImage?
    let fullName: String
    let shortName: String
}
