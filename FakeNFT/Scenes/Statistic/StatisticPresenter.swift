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
        model.fetchStatistic(page: 0, size: size, sortBy: sortBy) { [weak self] _, current in
            self?.view?.updateStatistic(current)
            self?.view?.stopLoading()
        }
    }
    
    func loadNextStatistic(indexPath: IndexPath) {
        if indexPath.row + 1 == model.users.count {
            
            let nextPage = lastLoadedPage + 1
            if lastRequestedPage == nextPage {
                Logger.shared.info("The same page, page=\(nextPage)")
                return
            }
            lastRequestedPage = nextPage
            self.view?.startLoading()
            model.fetchStatistic(page: nextPage, size: size, sortBy: sortBy) { [weak self] all, current in
                self?.view?.updateStatistic(all)
                if !current.isEmpty {
                    self?.lastLoadedPage = nextPage
                }
                self?.view?.stopLoading()
            }
        }
    }
    
    func openProfile(indexPath: IndexPath) {
        
    }
}
