//
//  CollectionNFTModel.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import Foundation

protocol CollectionNFTModelProtocol: AnyObject {
    func getCollection() -> Collection
}

final class CollectionNFTModel: CollectionNFTModelProtocol {

    weak var presenter: CollectionNFTPresenterProtocol?

    // MARK: - Private Properties

    private var nftService: NFTService
    private var collection: Collection

    private var nfts: [NFT] = []

    // MARK: - Initializers

    init(nftService: NFTService, collection: Collection) {
        self.nftService = nftService
        self.collection = collection
    }

    func getCollection() -> Collection {
        collection
    }
}
