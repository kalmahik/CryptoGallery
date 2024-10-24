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

    func loadNfts(sort: NftRequest.NftSort)
    func viewDidLoad()
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
    var isLoading = false

    // MARK: - Private Properties

    private var nftIds: [String] = []
    private let repository: MyNftRepository
    private var currentSort: NftRequest.NftSort = .rating

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
        loadNfts(sort: currentSort)
        fetchUserLikes()
    }
}

// MARK: - MyNftPresenterProtocol

extension MyNftPresenter: MyNftPresenterProtocol {

    func loadNfts(sort: NftRequest.NftSort) {
        guard !isLoading else { return }
        isLoading = true
        view?.reloadData()

        repository.fetchAllNfts(nftIds: nftIds, sort: sort) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let nfts):
                    self.handleNewNfts(nfts)
                case .failure(let error):
                    Logger.shared.error("Ошибка загрузки NFT: \(error.localizedDescription)")
                    self.handleError(error)
                }
            }
        }
    }

    func refreshData() {
        guard !isLoading else { return }
        loadNfts(sort: currentSort)
    }

    func setSortType(_ sort: NftRequest.NftSort) {
        guard currentSort != sort else { return }
        currentSort = sort

        if let safeSortType = SortType(rawValue: sort.rawValue) {
            UserDefaults.standard.saveSortType(safeSortType)
        } else {
            Logger.shared.error("Ошибка: Невозможно сохранить неизвестный тип сортировки.")
        }

        refreshData()
    }
}

// MARK: - Like Handler

extension MyNftPresenter {

    @discardableResult
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
                }
            }
        }
    }

    private func fetchUserLikes() {
        repository.fetchUserLikes { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likes):
                    self.likedNftIds = likes
                    self.updateLikesInView()
                case .failure(let error):
                    Logger.shared.error("[MyNftPresenter] - Ошибка получения лайков пользователя: \(error.localizedDescription)")
                    self.likedNftIds = []
                }
            }
        }
    }

    private func updateLikesInView() {
        for (index, nft) in nfts.enumerated() {
            isLiked(nft: nft)
            view?.reloadRow(at: index)
        }
    }

    private func handleNewNfts(_ newNfts: [NFT]) {
        nfts = newNfts
        sortAllNfts(by: currentSort)
        view?.reloadData()
    }

    private func handleError(_ error: Error) {
        let errorMessage = (error as? CustomError)?.localizedDescription ?? LocalizationKey.errorUnknown.localized()
        view?.showError(message: errorMessage)
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
