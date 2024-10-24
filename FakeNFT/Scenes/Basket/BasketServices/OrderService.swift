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
    private let logger = Logger.shared

    // MARK: - Initialization

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    // MARK: - Public Methods

    func fetchOrder(completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        logger.info("Начало запроса на получение заказа")
        let request = OrderRequesting()
        client.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let orderResponse):
                self.logger.debug("Заказ успешно получен: \(orderResponse)")
                completion(.success(orderResponse))
            case .failure(let error):
                self.logger.error("Ошибка при получении заказа: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func fetchNFT(by nftId: String, completion: @escaping (Result<NFTResponse, Error>) -> Void) {
        logger.info("Начало запроса на получение NFT с ID: \(nftId)")
        let request = NFTRequesting(nftId: nftId)
        client.send(request: request, type: NFTResponse.self) { result in
            switch result {
            case .success(let nftResponse):
                self.logger.debug("NFT \(nftId) успешно получен: \(nftResponse)")
                completion(.success(nftResponse))
            case .failure(let error):
                self.logger.error("Ошибка при получении NFT \(nftId): \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func fetchOrderAndNFTs(completion: @escaping (Result<[NFTResponse], Error>) -> Void) {
        logger.info("Начало запроса на получение заказа и связанных с ним NFT")
        fetchOrder { orderResult in
            switch orderResult {
            case .success(let orderResponse):
                self.logger.debug("Заказ успешно получен: \(orderResponse)")
                var nftResponses: [NFTResponse] = []
                let group = DispatchGroup()
                for nftId in orderResponse.nfts {
                    group.enter()
                    self.fetchNFT(by: nftId) { nftResult in
                        switch nftResult {
                        case .success(let nftResponse):
                            self.logger.debug("NFT \(nftId) успешно добавлен в список")
                            nftResponses.append(nftResponse)
                        case .failure(let error):
                            self.logger.error("Ошибка получения NFT \(nftId): \(error.localizedDescription)")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self.logger.info("Все запросы на получение NFT завершены")
                    completion(.success(nftResponses))
                }
            case .failure(let error):
                self.logger.error("Ошибка при получении заказа: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
