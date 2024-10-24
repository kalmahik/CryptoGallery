//
//  ProfileRepository.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 24.10.2024.
//

import Foundation

protocol ProfileRepository {
    func fetchUserProfile(completion: @escaping ProfileCompletion)
    func updateProfile(
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?,
        completion: @escaping ProfileCompletion
    )
}

final class ProfileRepositoryImpl: ProfileRepository {
    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func fetchUserProfile(completion: @escaping ProfileCompletion) {
        profileService.getProfile(completion: completion)
    }

    func updateProfile(
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?,
        completion: @escaping ProfileCompletion
    ) {
        profileService.updateProfile(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes,
            completion: completion
        )
    }
}
