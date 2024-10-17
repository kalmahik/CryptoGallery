//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 16.10.2024.
//

import Foundation

typealias CollectionCompletion = (Result<[Collection], Error>) -> Void

protocol CatalogService {

}

final class CatalogServiceImpl: CatalogService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient

    // MARK: - Initializers

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - GET

    func getCollections(completion: @escaping CollectionCompletion) {
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
}
