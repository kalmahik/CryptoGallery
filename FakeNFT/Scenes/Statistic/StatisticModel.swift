//
//  StatisticModel.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

final class StatisticModel {
    private let servicesAssembly: ServicesAssembly
    private var users: [Statistic] = []
    private var current: [Statistic] = []
    private var sortBy: SortBy = .rating
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func fetchStatistic(
        page: Int,
        size: Int,
        completion: @escaping (_ all: [Statistic], _ current: [Statistic]) -> Void
    ) {
        DispatchQueue.global().async {
            self.servicesAssembly.statisticService.sendStatisticGetRequest(
                page: page,
                size: size,
                sortBy: self.sortBy
            ) { [weak self] result in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.users.append(contentsOf: success)
                        current = success
                        switch sortBy {
                        case .rating:
                            users.sort { $0.rating > $1.rating}
                            current.sort { $0.rating > $1.rating}
                        case .name:
                            users = users.reversed()
                            current = success.reversed()
                            break
                        }
                        completion(users, current)
                    }
                case .failure(let error):
                    Logger.shared.warning(error.localizedDescription)
                }
            }
        }
    }
    
    func getStatistics() -> [Statistic] {
        users
    }
    
    func applySort(by sortBy: SortBy) {
        self.sortBy = sortBy
        servicesAssembly.statisticService.saveSortBy(sortBy: sortBy)
    }
    
    func getSort() -> SortBy {
        sortBy = servicesAssembly.statisticService.getSortBy()
        return sortBy
    }
}
