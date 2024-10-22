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
    func setSortType(_ sort: NftRequest.NftSort)
}

final class MyNftPresenter {

    // MARK: - Public Properties

    weak var view: MyNftProtocol?
    var nfts: [NFT] = []

    // MARK: - Private Properties

    private var nftIds: [String] = []
    private let nftService: MyNftService

    private var currentPage = 1
    private let pageSize = 10
    private var isLoading = false
    private var allDataLoaded = false

    private var currentSort: NftRequest.NftSort = .rating

    init(nfts: [NFT], nftService: MyNftService, nftIds: [String]) {
        self.nfts = nfts
        self.nftService = nftService
        self.nftIds = nftIds
    }

    func viewDidLoad() {
        let savedSortType = UserDefaults.standard.loadSortType()

        switch savedSortType {
        case .price:
            currentSort = .price
        case .rating:
            currentSort = .rating
        case .name:
            currentSort = .name
        default:
            break
        }

        loadNfts(page: 1, size: 20, sort: currentSort)
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
        if currentItemIndex >= nfts.count - 3 {
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
