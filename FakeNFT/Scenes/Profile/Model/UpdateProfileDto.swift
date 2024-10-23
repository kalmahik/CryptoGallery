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

    func asDictionary() -> [String: Any] {
        var dict: [String: String] = [:]
        if let name {
            dict["name"] = name
        }
        if let avatar {
            dict["avatar"] = avatar
        }
        if let description {
            dict["description"] = description
        }
        if let website {
            dict["website"] = website
        }
        if let likes {
            dict["likes"] = likes.joined(separator: ",")
        }
        return dict
    }
}
