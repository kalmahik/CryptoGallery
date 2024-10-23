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

    // MARK: - GET Profile

    func getProfile(completion: @escaping ProfileCompletion) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            let request = ProfileRequest()

            self.networkClient.send(request: request, type: Profile.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        completion(.success(profile))
                    case .failure(let error):
                        let customError = self.handleNetworkError(error)
                        completion(.failure(customError))
                    }
                }
            }
        }
    }

    // MARK: - PUT Profile

    func updateProfile(
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?,
        completion: @escaping ProfileCompletion
    ) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            let dto = UpdateProfileDto(
                name: name,
                avatar: avatar,
                description: description,
                website: website,
                likes: likes
            )

            Logger.shared.debug("[ProfileService] - Тело запроса: \(dto.asDictionary())")

            let request = UpdateProfileRequest(dto: dto)

            self.networkClient.send(request: request) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.getProfile(completion: completion)
                    case .failure(let error):
                        let customError = self.handleNetworkError(error)
                        completion(.failure(customError))
                    }
                }
            }
        }
    }

    // MARK: - Network Error Handling

    private func handleNetworkError(_ error: Error) -> Error {
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let statusCode):
                return self.mapErrorForStatusCode(statusCode)
            default:
                return NetworkClientError.urlSessionError
            }
        }
        return NetworkClientError.urlSessionError
    }

    private func mapErrorForStatusCode(_ statusCode: Int) -> Error {
        switch statusCode {
        case 400: return CustomError.badRequest
        case 401: return CustomError.unauthorized
        case 404: return CustomError.profileNotFound
        case 500: return CustomError.serverError
        case 502: return CustomError.serviceUnavailable
        default: return CustomError.unknownError(statusCode)
        }
    }
}

// MARK: - CustomError Handler

enum CustomError: Error {
    case badRequest
    case unauthorized
    case profileNotFound
    case serverError
    case serviceUnavailable
    case unknownError(Int)

    var localizedDescription: String {
        switch self {
        case .badRequest: return LocalizationKey.errorBadRequest.localized()
        case .unauthorized: return LocalizationKey.errorUnauthorized.localized()
        case .profileNotFound: return LocalizationKey.errorProfileNotFound.localized()
        case .serverError: return LocalizationKey.errorServer.localized()
        case .serviceUnavailable: return LocalizationKey.errorServiceUnavailable.localized()
        case .unknownError(let code): return "\(LocalizationKey.errorNetworkDescription.localized()), \(code))"
        }
    }
}
