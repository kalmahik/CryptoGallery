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
    var pageSize: Int { get }
    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort)
    func viewDidLoad()
    func loadMoreNftsIfNeeded(currentItemIndex: Int)
    func setSortType(_ sort: NftRequest.NftSort)
    func isLiked(nft: NFT) -> Bool
    func toggleLike(for nft: NFT)
}

final class MyNftPresenter {

    // MARK: - Public Properties

    weak var view: MyNftProtocol?
    var nfts: [NFT] = []
    var likedNftIds: [String] = []
    let pageSize = 10

    // MARK: - Private Properties

    private var nftIds: [String] = []
    private let nftService: MyNftService
    private var currentPage = 1
    private var isLoading = false
    private var allDataLoaded = false

    private var currentSort: NftRequest.NftSort = .rating

    init(nfts: [NFT], nftService: MyNftService, nftIds: [String]) {
        self.nfts = nfts
        self.nftService = nftService
        self.nftIds = nftIds
        self.likedNftIds = UserDefaults.standard.loadLikedNftIds()
    }

    func viewDidLoad() {
        loadNfts(page: 1, size: 20, sort: currentSort)
    }
}

// MARK: - MyNftPresenterProtocol

extension MyNftPresenter: MyNftPresenterProtocol {

    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort) {
        guard !isLoading, !allDataLoaded else { return }

        isLoading = true
        nftService.loadNftsByIds(ids: nftIds, page: page, size: size) { [weak self] (result: Result<[NFT], Error>) in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let nfts):
                if nfts.isEmpty {
                    self.allDataLoaded = true
                } else {
                    let sortedNfts = self.sortNfts(nfts, by: sort)
                    self.nfts.append(contentsOf: sortedNfts)
                    self.view?.reloadData()
                }
            case .failure(let error):
                Logger.shared.error("Ошибка загрузки NFT: \(error.localizedDescription)")
            }
        }
    }

    func loadMoreNftsIfNeeded(currentItemIndex: Int) {
        guard !isLoading, !allDataLoaded else { return }

        if currentItemIndex >= nfts.count - 1 {
            currentPage += 1
            loadNfts(page: currentPage, size: pageSize, sort: currentSort)
        }
    }

    func setSortType(_ sort: NftRequest.NftSort) {
        currentSort = sort
        currentPage = 1
        nfts = []
        view?.reloadData()

        if let safeSortType = SortType(rawValue: sort.rawValue) {
            UserDefaults.standard.saveSortType(safeSortType)
        } else {
            Logger.shared.error("Ошибка: Невозможно сохранить неизвестный тип сортировки.")
        }

        loadNfts(page: 1, size: pageSize, sort: currentSort)
    }

    private func sortNfts(_ nfts: [NFT], by sort: NftRequest.NftSort) -> [NFT] {
        switch sort {
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
    }
}

// MARK: - Like Handler

extension MyNftPresenter {

    func toggleLike(for nft: NFT) {
        if let index = likedNftIds.firstIndex(of: nft.id) {
            likedNftIds.remove(at: index)
        } else {
            likedNftIds.append(nft.id)
        }
        saveLikedNftIds()
    }

    func isLiked(nft: NFT) -> Bool {
        return likedNftIds.contains(nft.id)
    }

    private func saveLikedNftIds() {
        UserDefaults.standard.saveLikedNftIds(likedNftIds)
    }
}
