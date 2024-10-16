//
//  UpdateProfileDto.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 16.10.2024.
//

import Foundation

struct UpdateProfileDto: Dto {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let likes: [String]?

    func asDictionary() -> [String: String] {
        var dict: [String: String] = [:]

        if let name,
           let avatar,
           let description,
           let website,
           let likes {
            dict["name"] = name
            dict["avatar"] = avatar
            dict["description"] = description
            dict["website"] = website
            dict["likes"] = likes.joined(separator: ",")
        }
        return dict
    }
}
