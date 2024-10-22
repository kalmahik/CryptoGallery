//
//  CustomNftStorage.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import Foundation

protocol MyNftStorage: AnyObject {
    func saveNft(_ nft: NFT)
    func getNft(with id: String) -> NFT?
}


final class MyNftStorageImpl: MyNftStorage {
    private var storage: [String: NFT] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NFT) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NFT? {
        syncQueue.sync {
            storage[id]
        }
    }
}
