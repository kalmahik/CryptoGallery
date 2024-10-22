//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 16.10.2024.
//

import Foundation

typealias CollectionCompletion = (Result<[Collection], Error>) -> Void

protocol CatalogService {
    func getCollections(completion: @escaping CollectionCompletion)
}

final class CatalogServiceImpl: CatalogService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient
    private let syncQueue = DispatchQueue(label: "sync-catalog-service-queue", qos: .background)

    // MARK: - Initializers

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - GET

    func getCollections(completion: @escaping CollectionCompletion) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            let request = CatalogRequest()

            self.networkClient.send(request: request, type: [Collection].self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let collection):
                        completion(.success(collection))
                    case .failure(let error):
                        completion(.failure(error))
                        Logger.shared.error("Error: \(String(describing: error))")
                    }
                }
            }
        }
    }
}
