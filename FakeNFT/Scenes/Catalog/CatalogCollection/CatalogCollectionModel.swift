//
//  CatalogCollectionModel.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 17.10.2024.
//

import Foundation

protocol CatalogCollectionModelProtocol: AnyObject {
    func fetchCatalog()
    func sortedName()
    func sortedQuantityNft()
    func getCollectionCount() -> Int
    func getCollectionCover(_ rowNumber: Int) -> String
    func getCollectionName(_ rowNumber: Int) -> String
    func getCollectionQuantityNft(_ rowNumber: Int) -> Int
}

final class CatalogCollectionModel: CatalogCollectionModelProtocol {
    weak var presenter: CatalogCollectionPresenterModelProtocol?

    // MARK: - Private Properties

    private var collections: [Collection] = []
    private var collectionsSort: [Collection] = []
    private var catalogService: CatalogService

    // MARK: - Initializers

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }

    // MARK: - Public Functions

    func fetchCatalog() {
        presenter?.didStartLoadingData()
        catalogService.getCollections() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collections = collections
                sortedQuantityNft()
                presenter?.didFinishLoadingData()
            case .failure(let error):
                self.presenter?.handleError(error)
                presenter?.didFinishLoadingData()
                Logger.shared.error("Error fetching catalog: \(error)")
            }
        }
    }

    func sortedName() {
        collectionsSort = collections.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        presenter?.reloadTable()
    }

    func sortedQuantityNft() {
        collectionsSort = collections.sorted { $0.nfts.count > $1.nfts.count }
        presenter?.reloadTable()
    }

    func getCollectionCount() -> Int {
        collectionsSort.count
    }

    func getCollectionCover(_ rowNumber: Int) -> String {
        collectionsSort[rowNumber].cover
    }

    func getCollectionName(_ rowNumber: Int) -> String {
        collectionsSort[rowNumber].name
    }

    func getCollectionQuantityNft(_ rowNumber: Int) -> Int {
        collectionsSort[rowNumber].nfts.count
    }
}
