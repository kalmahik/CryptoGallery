//
//  StatisticPresenterProtocol.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

protocol StatisticPresenterProtocol {
    func viewDidLoad()
    func loadStatistic()
    func loadNextStatistic(indexPath: IndexPath)
    func openProfile(indexPath: IndexPath)
}
