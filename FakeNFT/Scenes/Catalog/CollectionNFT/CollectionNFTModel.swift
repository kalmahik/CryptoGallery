//
//  CollectionNFTModel.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import Foundation

protocol CollectionNFTModelProtocol: AnyObject {
    func fetchAllNFTs()
    func fetchLikes()
    func getCollection() -> Collection
    func getCountNFTs() -> Int
    func getNFT(_ rowNumber: Int) -> NFT
    func getStatusLike(_ rowNumber: Int) -> Bool
}

final class CollectionNFTModel: CollectionNFTModelProtocol {

    weak var presenter: CollectionNFTPresenterModelProtocol?

    // MARK: - Private Properties

    private var nftService: NFTService
    private var likesService: LikesService
    private var collection: Collection
    private var nftsId: Set<String>

    private var nfts: [NFT] = []
    private var isNFTSFetched = false
    private var likes: [String] = []
    private var isLikesFetched = false

    // MARK: - Initializers

    init(nftService: NFTService, likesService: LikesService, collection: Collection) {
        self.nftService = nftService
        self.likesService = likesService
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
            self?.isNFTSFetched = true
            self?.loadingCompleted()
        }
    }

    func fetchLikes() {
        likesService.getLikes() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let likes):
                self.likes = likes.likes
                self.isLikesFetched = true
                self.loadingCompleted()
            case .failure(let error):
                Logger.shared.error("Error fetching catalog: \(error)")
            }
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

    func getStatusLike(_ rowNumber: Int) -> Bool {
        likes.contains(nfts[rowNumber].id)
    }

    private func loadingCompleted() {
        if isNFTSFetched && isLikesFetched {
            presenter?.updateData()
            presenter?.didFinishLoadingData()
        }
    }
}
