//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import Foundation

protocol CollectionNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getCollection() -> Collection
    func getCountNFTs() -> Int
    func getNFT(_ rowNumber: Int) -> NFT
}

protocol CollectionNFTPresenterModelProtocol: AnyObject {
    func updateData()
    func didStartLoadingData()
    func didFinishLoadingData()
}

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
    func viewDidLoad() {
        model.fetchAllNFTs()
    }

    func getCollection() -> Collection {
        model.getCollection()
    }

    func getCountNFTs() -> Int {
        model.getCountNFTs()
    }

    func getNFT(_ rowNumber: Int) -> NFT {
        model.getNFT(rowNumber)
    }
}

// MARK: - CollectionNFTPresenterModelProtocol

extension CollectionNFTPresenter: CollectionNFTPresenterModelProtocol {
    func updateData() {
        view?.reloadCollection()
    }

    func didStartLoadingData() {
        view?.showindicator()
    }

    func didFinishLoadingData() {
        view?.hideIndicator()
    }
}
