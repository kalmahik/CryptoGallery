//
//  CustomNftService.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import Foundation

typealias MyNftCompletion = (Result<NFT, Error>) -> Void

protocol MyNftService {
    func loadNft(id: String, completion: @escaping MyNftCompletion)
    func loadAllNfts(ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void)
}

final class MyNftServiceImpl: MyNftService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient
    private let storage: MyNftStorage

    // MARK: - Init

    init(networkClient: NetworkClient, storage: MyNftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    // MARK: - Public Methods

    func loadNft(id: String, completion: @escaping MyNftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: NFT.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadAllNfts(ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void) {
        let uniqueIds = Array(Set(ids))
        var nfts: [NFT] = []
        let group = DispatchGroup()

        for id in uniqueIds {
            group.enter()
            loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    Logger.shared.error("Ошибка загрузки NFT с id \(id): \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(.success(nfts))
        }
    }
}
