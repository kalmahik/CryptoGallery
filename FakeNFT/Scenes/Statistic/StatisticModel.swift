//
//  StatisticModel.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

final class StatisticModel {
    private let statisticService: StatisticService
    var users: [Statistic] = []
    
    init(statisticService: StatisticService) {
        self.statisticService = statisticService
    }
    
    func fetchStatistic(
page: Int,
size: Int,
sortBy: SortBy,
completion: @escaping (_ all: [Statistic], _ current: [Statistic]) -> Void) {
        DispatchQueue.global().async {
            self.statisticService.sendStatisticGetRequest(
                page: page,
                size: size,
                sortBy: sortBy
            ) { [weak self] result in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.users.append(contentsOf: success)
                        completion(users, success)
                    }
                case .failure(let error):
                    Logger.shared.warning(error.localizedDescription)
                }
            }
        }
    }
}
