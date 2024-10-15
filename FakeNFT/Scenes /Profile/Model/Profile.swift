//
//  Profile.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String?
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
