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
    private let profileService: ProfileService

    private var currentSort: NftRequest.NftSort = .rating

    init(nfts: [NFT], nftService: MyNftService, profileService: ProfileService, nftIds: [String]) {
        self.nfts = nfts
        self.nftService = nftService
        self.nftIds = nftIds
        self.profileService = profileService
    }

    func viewDidLoad() {
        getProfileDataForLikes()
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

            let updatedLikes: [String]? = likedNftIds.isEmpty ? nil : likedNftIds

            updateProfileWithLikes(updatedLikes: updatedLikes)
        } else {
            likedNftIds.append(nft.id)
            updateProfileWithLikes(updatedLikes: likedNftIds)
        }

        if let index = nfts.firstIndex(where: { $0.id == nft.id }) {
            view?.reloadRow(at: index)
        }
    }

    func isLiked(nft: NFT) -> Bool {
        let isLiked = likedNftIds.contains(nft.id)
        return isLiked
    }

    func updateProfileWithLikes(updatedLikes: [String]?) {
        profileService.getProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                let likesToSend: Any = (updatedLikes?.isEmpty ?? true) ? "null" : updatedLikes!

                self.profileService.updateProfile(
                    name: profile.name,
                    avatar: profile.avatar,
                    description: profile.description,
                    website: profile.website,
                    likes: likesToSend as? [String]
                ) { updateResult in
                    switch updateResult {
                    case .success:
                        self.view?.reloadData()
                    case .failure(let error):
                        Logger.shared.error("[MyNftPresenter] - Ошибка при обновлении профиля: \(error.localizedDescription)")
                        self.getProfileDataForLikes()
                        self.view?.reloadData()
                    }
                }
            case .failure(let error):
                Logger.shared.error("[MyNftPresenter] - Ошибка получения профиля для обновления лайков: \(error.localizedDescription)")
            }
        }
    }

    private func getProfileDataForLikes() {
        profileService.getProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.likedNftIds = profile.likes
                self?.loadNfts(page: 1, size: 20, sort: self?.currentSort ?? .rating)
            case .failure(let error):
                Logger.shared.error("[MyNftPresenter] - Ошибка получения профиля для лайков: \(error.localizedDescription)")
            }
        }
    }
}
