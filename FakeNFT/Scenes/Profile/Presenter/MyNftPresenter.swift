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
    var isLoading: Bool { get set }
    var currentPage: Int { get }
    var pageSize: Int { get }
    var allDataLoaded: Bool { get }

    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort)
    func viewDidLoad()
    func loadMoreNftsIfNeeded(currentItemIndex: Int)
    func setSortType(_ sort: NftRequest.NftSort)
    func isLiked(nft: NFT) -> Bool
    func toggleLike(for nft: NFT)
    func refreshData()
}

final class MyNftPresenter {

    // MARK: - Public Properties

    weak var view: MyNftProtocol?
    var nfts: [NFT] = []
    var likedNftIds: [String] = []
    var currentPage = 1
    let pageSize = 10
    var isLoading = false
    var allDataLoaded = false

    // MARK: - Private Properties

    private var nftIds: [String] = []
    private let repository: MyNftRepository
    private var currentSort: NftRequest.NftSort = .rating
    private var errorLoadAttempts = 0
    private let maxErrorAttempts = 3

    // MARK: - Init

    init(repository: MyNftRepository, nftIds: [String]) {
        self.repository = repository
        self.nftIds = Array(Set(nftIds))
    }

    // MARK: - Lifecycly

    func viewDidLoad() {
        if let savedSortType = UserDefaults.standard.loadSortType() {
            currentSort = NftRequest.NftSort(rawValue: savedSortType.rawValue) ?? .rating
        } else {
            currentSort = .rating
        }

        fetchUserLikes()
    }
}

// MARK: - MyNftPresenterProtocol

extension MyNftPresenter: MyNftPresenterProtocol {

    func loadNfts(page: Int, size: Int, sort: NftRequest.NftSort) {
        guard !isLoading, !allDataLoaded else { return }
        isLoading = true

        repository.fetchNfts(nftIds: nftIds, page: page, size: size, sort: sort) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let newNfts):
                    self.handleNewNfts(newNfts, page: page)
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    func refreshData() {
        guard !isLoading else { return }

        allDataLoaded = false
        currentPage = 1
        errorLoadAttempts = 0

        loadNfts(page: currentPage, size: pageSize, sort: currentSort)
    }

    func loadMoreNftsIfNeeded(currentItemIndex: Int) {
        guard !isLoading, !allDataLoaded else { return }

        if currentItemIndex >= nfts.count - 1 {
            currentPage += 1
            loadNfts(page: currentPage, size: pageSize, sort: currentSort)
        }
    }

    func setSortType(_ sort: NftRequest.NftSort) {
        guard currentSort != sort else { return }
        currentSort = sort

        if let safeSortType = SortType(rawValue: sort.rawValue) {
            UserDefaults.standard.saveSortType(safeSortType)
        } else {
            Logger.shared.error("Ошибка: Невозможно сохранить неизвестный тип сортировки.")
        }

        sortAllNfts(by: currentSort)
        view?.reloadData()
    }
}

// MARK: - Like Handler

extension MyNftPresenter {

    func isLiked(nft: NFT) -> Bool {
        return likedNftIds.contains(nft.id)
    }

    func toggleLike(for nft: NFT) {
        if let index = likedNftIds.firstIndex(of: nft.id) {
            likedNftIds.remove(at: index)
        } else {
            likedNftIds.append(nft.id)
        }

        repository.updateUserLikes(likedNftIds: likedNftIds) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(
                        name: .nftLikeStatusChanged,
                        object: nil,
                        userInfo: ["nftId": nft.id, "isLiked": self.likedNftIds.contains(nft.id)]
                    )
                    if let index = self.nfts.firstIndex(where: { $0.id == nft.id }) {
                        self.view?.reloadRow(at: index)
                    }
                case .failure(let error):
                    Logger.shared.error("[MyNftPresenter] - Ошибка при обновлении лайков: \(error.localizedDescription)")
                    self.fetchUserLikes()
                }
            }
        }
    }

    private func fetchUserLikes() {
        repository.fetchUserLikes { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likes):
                    self.likedNftIds = likes
                    self.loadNfts(page: self.currentPage, size: self.pageSize, sort: self.currentSort)
                case .failure(let error):
                    Logger.shared.error("[MyNftPresenter] - Ошибка получения лайков пользователя: \(error.localizedDescription)")
                    self.view?.reloadData()
                }
            }
        }
    }

    private func handleNewNfts(_ newNfts: [NFT], page: Int) {
        errorLoadAttempts = 0
        if newNfts.count < pageSize {
            allDataLoaded = true
        }

        let existingIds = Set(nfts.map { $0.id })
        let uniqueNewNfts = newNfts.filter { !existingIds.contains($0.id) }
        nfts.append(contentsOf: uniqueNewNfts)

        sortAllNfts(by: currentSort)
        view?.reloadData()
    }

    private func handleError(_ error: Error) {
        errorLoadAttempts += 1
        Logger.shared.error("Ошибка загрузки NFT: \(error.localizedDescription)")

        if errorLoadAttempts >= maxErrorAttempts {
            allDataLoaded = true
        }
        view?.reloadData()
    }

    private func sortAllNfts(by sort: NftRequest.NftSort) {
        switch sort {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name.lowercased() < $1.name.lowercased() }
        }
    }
}
