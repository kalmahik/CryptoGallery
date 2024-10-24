//
//  EditProfileRepository.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 24.10.2024.
//

import Foundation

protocol EditProfileRepository {
    func saveProfileChanges(
        updatedProfile: Profile,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
}

final class EditProfileRepositoryImpl: EditProfileRepository {
    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func saveProfileChanges(
        updatedProfile: Profile,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        profileService.updateProfile(
            name: updatedProfile.name,
            avatar: updatedProfile.avatar,
            description: updatedProfile.description,
            website: updatedProfile.website,
            likes: updatedProfile.likes,
            completion: completion
        )
    }
}
