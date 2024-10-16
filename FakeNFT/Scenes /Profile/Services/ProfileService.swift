//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 16.10.2024.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func getProfile(completion: @escaping ProfileCompletion)
    func updateProfile(
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?,
        completion: @escaping ProfileCompletion
    )
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient
    private let syncQueue = DispatchQueue(label: "sync-profile-service-queue", qos: .background)

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - GET
    func getProfile(completion: @escaping ProfileCompletion) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            let request = ProfileRequest()

            self.networkClient.send(request: request, type: Profile.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                        Logger.shared.error("Error: \(String(describing: error))")
                    }
                }
            }
        }
    }

    // MARK: - PUT
    func updateProfile(
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?,
        completion: @escaping ProfileCompletion
    ) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            let dto = UpdateProfileDto(
                name: name,
                avatar: avatar,
                description: description,
                website: website,
                likes: likes
            )
            let request = UpdateProfileRequest(dto: dto)
            self.networkClient.send(request: request, type: Profile.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                        Logger.shared.error("Error: \(String(describing: error))")
                    }
                }
            }
        }
    }
}
