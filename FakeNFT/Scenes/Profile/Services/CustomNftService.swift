//
//  CustomNftService.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import Foundation

typealias CustomNftCompletion = (Result<NFT, Error>) -> Void

protocol CustomNftService {
    func loadNft(id: String, completion: @escaping CustomNftCompletion)
    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort, completion: @escaping (Result<[NFT], Error>) -> Void)
    func loadNftsByIds(ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void)
}

final class CustomNftServiceImpl: CustomNftService {

    private let networkClient: NetworkClient
    private let storage: CustomNftStorage

    init(networkClient: NetworkClient, storage: CustomNftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping CustomNftCompletion) {
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

    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort, completion: @escaping (Result<[NFT], Error>) -> Void) {
        let request = NftRequest(page: page, size: size, sort: sort)
        networkClient.send(request: request, type: [NFT].self) { result in
            switch result {
            case .success(let nfts):
                completion(.success(nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNftsByIds(ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void) {
        var nfts: [NFT] = []
        let group = DispatchGroup()

        for id in ids {
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
            if nfts.isEmpty {
                completion(.failure(NetworkClientError.parsingError))
            } else {
                completion(.success(nfts))
            }
        }
    }
}
