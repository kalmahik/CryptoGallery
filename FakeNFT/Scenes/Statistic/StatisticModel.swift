//
//  StatisticModel.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

final class StatisticModel {
    private let statisticService: StatisticService
    private var users: [Statistic] = []
    
    init(statisticService: StatisticService) {
        self.statisticService = statisticService
    }
    
    func fetchStatistic(completion: @escaping ([Statistic]) -> Void) {
        DispatchQueue.global().async {
            self.statisticService.sendStatisticGetRequest { [weak self] result in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self?.users = success
                        completion(success)
                    }
                case .failure(let error):
                    Logger.shared.warning(error.localizedDescription)
                }
            }
        }
    }
}
