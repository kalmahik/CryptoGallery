//
//  MyNftPresenter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import Foundation

protocol MyNftPresenterProtocol: AnyObject {
    var view: MyNftProtocol? { get set }
    var nfts: [NFT] { get set }
    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort)
    func viewDidLoad()
}

final class MyNftPresenter {

    weak var view: MyNftProtocol?
    var nfts: [NFT] = []

    private let nftService: CustomNftService

    init(nfts: [NFT], nftService: CustomNftService) {
        self.nfts = nfts
        self.nftService = nftService
    }

    func viewDidLoad() {}
}

// MARK: - MyNftPresenterProtocol

extension MyNftPresenter: MyNftPresenterProtocol {

    func loadNfts(page: Int = 1, size: Int = 10, sort: NftRequest.NftSort = .rating) {
        nftService.loadNfts(page: page, size: size, sort: sort) { [weak self] (result: Result<[NFT], Error>) in
            switch result {
            case .success(let nfts):
                self?.nfts = nfts
                self?.view?.reloadData()
            case .failure(let error):
                Logger.shared.error("Error loading NFTs: \(error.localizedDescription)")
            }
        }
    }
}
