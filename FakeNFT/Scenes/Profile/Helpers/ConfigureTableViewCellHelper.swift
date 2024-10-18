//
//  ConfigureTableViewCellHelper.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 14.10.2024.
//

import UIKit

final class ConfigureTableViewCellHelper {

    static func configureTableViewCell(
        _ cell: ProfileCell,
        title: String,
        at indexPath: IndexPath,
        myNFTValue: Int,
        selectedNFTValue: Int
    ) {
        cell.selectionStyle = .none
        var categoryTitle = ""

        switch indexPath.row {
        case 0:
            categoryTitle = (myNFTValue > 0) ? "\(title) (\(myNFTValue))" : title
        case 1:
            categoryTitle = (selectedNFTValue > 0) ? "\(title) (\(selectedNFTValue))" : title
        default:
            categoryTitle = title
        }
        cell.configure(with: categoryTitle)
    }
}
