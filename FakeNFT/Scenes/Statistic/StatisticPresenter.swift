//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

final class StatisticPresenter: StatisticPresenterProtocol {
    weak var view: StatisticViewProtocol?
    private var model: StatisticModel
    private var lastRequestedPage = 0
    private var lastLoadedPage = 0
    private let size = 10
//    private var sortBy: SortBy = .rating
    private var users: [Statistic] = []
    
    init(model: StatisticModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        view?.setupView()
        view?.setupConstraints()
        view?.setNavigationItem()
        loadStatistic()
    }
    
    func loadStatistic() {
        view?.startLoading()
        model.fetchStatistic(page: 0, size: size) { [weak self] _, current in
            self?.users = current
            self?.view?.updateStatistic()
            self?.view?.stopLoading()
        }
    }
    
    func loadNextStatistic(indexPath: IndexPath) {
        if indexPath.row + 1 == model.getStatistics().count {
            let nextPage = lastLoadedPage + 1
            if lastRequestedPage == nextPage {
                Logger.shared.info("The same page, page=\(nextPage)")
                return
            }
            lastRequestedPage = nextPage
            self.view?.startLoading()
            model.fetchStatistic(page: nextPage, size: size) { [weak self] all, current in
                self?.users = all
                self?.view?.updateStatistic()
                if !current.isEmpty {
                    self?.lastLoadedPage = nextPage
                }
                self?.view?.stopLoading()
            }
        }
    }
    
    func getUserList() -> [Statistic] {
        self.users
    }
    
    func openProfile(indexPath: IndexPath) {
        
    }
    
    func applySort(by sortBy: SortBy) {
        
    }
}
