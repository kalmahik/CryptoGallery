//
//  Collection.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 14.10.2024.
//

import Foundation

struct Collection: Decodable {
    let name: String
    let cover: String
    let nfts: [Int]
    let description: String
    let author: String
    let id: String
}
