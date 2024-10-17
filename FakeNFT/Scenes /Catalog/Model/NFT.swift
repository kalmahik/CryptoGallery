//
//  NFT.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 16.10.2024.
//

import Foundation

struct NFT: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: String
    let description: String
    let price: String
    let author: String
    let id: String
}
