//
//  StatisticViewProtocol.swift
//  FakeNFT
//
//  Created by kalmahik on 18.10.2024.
//

import Foundation

protocol StatisticViewProtocol: AnyObject {
    func setupView()
    func setupConstraints()
    func setNavigationItem()
    func updateStatistic()
    func startLoading()
    func stopLoading()
}
