//
//  SortManager.swift
//  FakeNFT
//
//  Created by Вадим on 15.10.2024.
//

import Foundation

// MARK: - Enum

enum SortOption: String {
    case price
    case rating
    case name
}

// MARK: - SortManager

final class SortManager {

    // MARK: - Private Properties

    private let sortKey = "selectedSortOption"

    // MARK: - Public Methods

    func saveSortOption(_ option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortKey)
    }

    func loadSortOption() -> SortOption {
        let savedOption = UserDefaults.standard.string(forKey: sortKey) ?? SortOption.name.rawValue
        return SortOption(rawValue: savedOption) ?? .name
    }
}
