//
//  NFTService.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 24.10.2024.
//

import Foundation

typealias NFTCompletion = (Result<NFT, Error>) -> Void

protocol NFTService: AnyObject {
    func getNFT(id: String, completion: @escaping NFTCompletion)
}

final class NFTServiceImpl: NFTService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient
    private let syncQueue = DispatchQueue(label: "sync-nft-service-queue", qos: .background)

    // MARK: - Initializers

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getNFT(id: String, completion: @escaping NFTCompletion) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            let request = NFTRequest(id: id)

            self.networkClient.send(request: request, type: NFT.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        completion(.success(nft))
                    case .failure(let error):
                        completion(.failure(error))
                        Logger.shared.error("Error: \(String(describing: error))")
                    }
                }
            }
        }
    }
}
