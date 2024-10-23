//
//  Profile.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 17.10.2024.
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

    static func emptyProfile() -> Profile {
        return Profile(
            name: "",
            avatar: nil,
            description: "",
            website: "",
            nfts: [],
            likes: [],
            id: UUID().uuidString
        )
    }
}
