//
//  Statistic.swift
//  FakeNFT
//
//  Created by kalmahik on 24.10.2024.
//

import Foundation

struct Statistic: Decodable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
