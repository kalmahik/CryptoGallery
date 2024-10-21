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
    func loadMoreNftsIfNeeded(currentItemIndex: Int)
}

final class MyNftPresenter {

    weak var view: MyNftProtocol?
    var nfts: [NFT] = []

    private var nftIds: [String] = []
    private let nftService: CustomNftService

    private var currentPage = 1
    private let pageSize = 10
    private var isLoading = false
    private var allDataLoaded = false

    init(nfts: [NFT], nftService: CustomNftService, nftIds: [String]) {
        self.nfts = nfts
        self.nftService = nftService
        self.nftIds = nftIds
    }

    func viewDidLoad() {
        loadNfts(page: 1, size: 20, sort: .rating)
    }
}

// MARK: - MyNftPresenterProtocol

extension MyNftPresenter: MyNftPresenterProtocol {

    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort) {
        guard !isLoading, !allDataLoaded else { return }

        isLoading = true
        nftService.loadNftsByIds(ids: nftIds, page: page, size: size) { [weak self] (result: Result<[NFT], Error>) in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let nfts):
                if nfts.isEmpty {
                    self.allDataLoaded = true
                } else {
                    self.nfts.append(contentsOf: nfts)
                    self.view?.reloadData()
                }
            case .failure(let error):
                Logger.shared.error("Ошибка загрузки NFT: \(error.localizedDescription)")
            }
        }
    }

    func loadMoreNftsIfNeeded(currentItemIndex: Int) {
        if currentItemIndex >= nfts.count - 3 {
            currentPage += 1
            loadNfts(page: currentPage, size: pageSize, sort: .rating)
        }
    }
}
