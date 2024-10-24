//
//  LikesService.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 24.10.2024.
//

import Foundation

typealias LikesCompletion = (Result<Likes, Error>) -> Void

protocol LikesService: AnyObject {
    func getLikes(completion: @escaping LikesCompletion)
}

final class LikesServiceImpl: LikesService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient
    private let syncQueue = DispatchQueue(label: "sync-likes-service-queue", qos: .background)

    // MARK: - Initializers

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getLikes(completion: @escaping LikesCompletion) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            let request = LikesRequest()

            self.networkClient.send(request: request, type: Likes.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let likes):
                        completion(.success(likes))
                    case .failure(let error):
                        completion(.failure(error))
                        Logger.shared.error("Error: \(String(describing: error))")
                    }
                }
            }
        }
    }
}
