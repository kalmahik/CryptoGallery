//
//  NFTService.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 24.10.2024.
//

import Foundation

protocol NFTService: AnyObject {}

final class NFTServiceImpl: NFTService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient
//    private let syncQueue = DispatchQueue(label: "sync-catalog-service-queue", qos: .background)

    // MARK: - Initializers

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}
