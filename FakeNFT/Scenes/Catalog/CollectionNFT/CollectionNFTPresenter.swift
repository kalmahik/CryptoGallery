//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import Foundation

protocol CollectionNFTPresenterProtocol: AnyObject {
    func getCollection() -> Collection
}

protocol CollectionNFTPresenterModelProtocol: AnyObject {}

final class CollectionNFTPresenter {

    weak var view: CollectionNFTViewControllerProtocol?

    // MARK: - Private Properties

    private var model: CollectionNFTModelProtocol

    // MARK: - Initializers

    init(model: CollectionNFTModelProtocol) {
        self.model = model
    }
}

// MARK: - CollectionNFTPresenterProtocol

extension CollectionNFTPresenter: CollectionNFTPresenterProtocol {
    func getCollection() -> Collection {
        model.getCollection()
    }
}

// MARK: - CollectionNFTPresenterModelProtocol

extension CollectionNFTPresenter: CollectionNFTPresenterModelProtocol {}
