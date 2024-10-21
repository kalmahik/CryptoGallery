//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

class StatisticPresenter: StatisticPresenterProtocol {
    weak var view: StatisticViewProtocol?
    var model: StatisticModel
    var lastRequestedPage = 0
    var lastLoadedPage = 0
    let size = 10
    var sortBy: SortBy = .rating

    init(view: StatisticViewProtocol, model: StatisticModel) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view?.setupView()
        view?.setupConstraints()
        view?.setNavigationItem()
        loadStatistic()
    }

    func loadStatistic() {
        model.fetchStatistic(page: 0, size: size, sortBy: sortBy) { [weak self] all, current in
            self?.view?.updateStatistic(all)
        }
    }
    
    func loadNextStatistic(indexPath: IndexPath) {
        let nextPage = lastLoadedPage + 1
        
        if lastRequestedPage == nextPage {
            Logger.shared.info("The same page, page=\(nextPage)")
            return
        }
        lastRequestedPage = nextPage
        if indexPath.row + 1 == model.users.count {
            model.fetchStatistic(page: nextPage, size: size, sortBy: sortBy) { [weak self] all, current in
                self?.view?.updateStatistic(all)
                self?.lastLoadedPage = nextPage
            }
        }
    }
    
    func openProfile(indexPath: IndexPath) {
        
    }
}
