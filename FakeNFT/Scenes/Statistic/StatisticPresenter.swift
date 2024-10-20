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
        model.fetchStatistic() { [weak self] statistic in
            self?.view?.updateStatistic(statistic)
        }
    }
}
