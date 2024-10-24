//
//  CatalogCollectionPresenter.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 12.10.2024.
//

import UIKit

protocol CatalogCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getCollectionCount() -> Int
    func getCollectionCover(_ rowNumber: Int) -> String
    func getCollectionName(_ rowNumber: Int) -> String
    func getCollectionQuantityNft(_ rowNumber: Int) -> Int
    func didSelectSortType(_ typeSorted: CatalogSortType)
}

protocol CatalogCollectionPresenterModelProtocol: AnyObject {
    func reloadTable()
    func didStartLoadingData()
    func didFinishLoadingData()
    func handleError(_ error: Error)
}

final class CatalogCollectionPresenter {
    weak var view: CatalogViewControllerProtocol?

    private var model: CatalogCollectionModelProtocol

    init(model: CatalogCollectionModelProtocol) {
        self.model = model
    }
}

// MARK: - CatalogCollectionPresenterProtocol

extension CatalogCollectionPresenter: CatalogCollectionPresenterProtocol {
    func viewDidLoad() {
        model.fetchCatalog()
    }

    func getCollectionCount() -> Int {
        model.getCollectionCount()
    }

    func getCollectionCover(_ rowNumber: Int) -> String {
        model.getCollectionCover(rowNumber)
    }

    func getCollectionName(_ rowNumber: Int) -> String {
        model.getCollectionName(rowNumber)
    }

    func getCollectionQuantityNft(_ rowNumber: Int) -> Int {
        model.getCollectionQuantityNft(rowNumber)
    }

    func didSelectSortType(_ typeSorted: CatalogSortType) {
        switch typeSorted {
        case .name:
            model.sortedName()
        case .quantityNft:
            model.sortedQuantityNft()
        }
    }
}

// MARK: - CatalogCollectionPresenterModelProtocol

extension CatalogCollectionPresenter: CatalogCollectionPresenterModelProtocol {
    func reloadTable() {
        view?.reloadCatalog()
    }

    func didStartLoadingData() {
        view?.showindicator()
    }

    func didFinishLoadingData() {
        view?.hideIndicator()
    }
}

// MARK: - Show Error
extension CatalogCollectionPresenter {
    func handleError(_ error: Error) {
        let textLocalizationSorting = LocalizationKey.statEmptyDataAlert.localized()
        let errorMessage = textLocalizationSorting

        let errorModel = ErrorModel(
            message: errorMessage,
            actionText: LocalizationKey.errorRepeat.localized(),
            action: { [weak self] in
                self?.model.fetchCatalog()
            }
        )

        if let view = self.view as? ErrorView {
            view.showError(errorModel)
        }
    }
}
