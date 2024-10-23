//
//  OrderService.swift
//  FakeNFT
//
//  Created by Вадим on 22.10.2024.
//

import Foundation

final class OrderService {

    // MARK: - Private Properties

    private let client: NetworkClient

    // MARK: - Initialization

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    // MARK: - Public Methods

    func fetchOrder(completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        let request = OrderRequesting()
        client.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let orderResponse):
                completion(.success(orderResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchNFT(by nftId: String, completion: @escaping (Result<NFTResponse, Error>) -> Void) {
        let request = NFTRequesting(nftId: nftId)
        client.send(request: request, type: NFTResponse.self) { result in
            switch result {
            case .success(let nftResponse):
                completion(.success(nftResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchOrderAndNFTs(completion: @escaping (Result<[NFTResponse], Error>) -> Void) {
        fetchOrder { orderResult in
            switch orderResult {
            case .success(let orderResponse):
                var nftResponses: [NFTResponse] = []
                let group = DispatchGroup()
                for nftId in orderResponse.nfts {
                    group.enter()
                    self.fetchNFT(by: nftId) { nftResult in
                        switch nftResult {
                        case .success(let nftResponse):
                            nftResponses.append(nftResponse)
                        case .failure(let error):
                            print("Ошибка при получении NFT \(nftId): \(error)")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(nftResponses))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
