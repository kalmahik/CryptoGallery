//
//  ProfileBuilder.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 17.10.2024.
//

import Foundation

final class ProfileBuilder {
    
    var currentName: String {
        return name
    }
    var currentAvatar: String? {
        return avatar
    }
    var currentDescription: String {
        return description
    }
    var currentWebsite: String {
        return website
    }

    private var name: String
    private var avatar: String?
    private var description: String
    private var website: String
    private var nfts: [String]
    private var likes: [String]
    private var id: String
    

    init(profile: Profile) {
        self.name = profile.name
        self.avatar = profile.avatar
        self.description = profile.description
        self.website = profile.website
        self.nfts = profile.nfts
        self.likes = profile.likes
        self.id = profile.id
    }

    func setName(_ name: String) -> ProfileBuilder {
        self.name = name
        return self
    }

    func setAvatar(_ avatar: String?) -> ProfileBuilder {
        self.avatar = avatar
        return self
    }

    func setDescription(_ description: String) -> ProfileBuilder {
        self.description = description
        return self
    }

    func setWebsite(_ website: String) -> ProfileBuilder {
        self.website = website
        return self
    }

    func setId(_ id: String) -> ProfileBuilder {
        self.id = id
        return self
    }

    func build() -> Profile {
        return Profile(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: nfts,
            likes: likes,
            id: id
        )
    }
}
