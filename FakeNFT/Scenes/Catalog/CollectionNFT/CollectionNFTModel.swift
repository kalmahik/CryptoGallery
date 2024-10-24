//
//  CollectionNFTModel.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import Foundation

protocol CollectionNFTModelProtocol: AnyObject {
    func fetchAllNFTs()
    func getCollection() -> Collection
    func getCountNFTs() -> Int
    func getNFT(_ rowNumber: Int) -> NFT
}

final class CollectionNFTModel: CollectionNFTModelProtocol {

    weak var presenter: CollectionNFTPresenterModelProtocol?

    // MARK: - Private Properties

    private var nftService: NFTService
    private var collection: Collection
    private var nftsId: Set<String>

    private var nfts: [NFT] = []

    // MARK: - Initializers

    init(nftService: NFTService, collection: Collection) {
        self.nftService = nftService
        self.collection = collection
        self.nftsId = Set(collection.nfts)
    }

    func fetchAllNFTs() {
        presenter?.didStartLoadingData()
        let dispatchGroup = DispatchGroup()
        for id in nftsId {
            dispatchGroup.enter()
            nftService.getNFT(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                case .failure(let error):
                    Logger.shared.error("Error fetching NFT: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.updateData()
            self?.presenter?.didFinishLoadingData()
        }
    }

    func getCollection() -> Collection {
        collection
    }

    func getCountNFTs() -> Int {
        nfts.count
    }

    func getNFT(_ rowNumber: Int) -> NFT {
        nfts[rowNumber]
    }
}
