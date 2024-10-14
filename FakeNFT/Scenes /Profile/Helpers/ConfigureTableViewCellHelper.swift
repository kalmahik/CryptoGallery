//
//  ConfigureTableViewCellHelper.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 14.10.2024.
//

import UIKit

final class ConfigureTableViewCellHelper {

    static func configureTableViewCell(
        _ cell: UITableViewCell,
        at indexPath: IndexPath
    ) {
        cell.selectionStyle = .none
        let indicatorImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        indicatorImageView.tintColor = .ypBlack
        cell.accessoryView = indicatorImageView
    }

    static func configureTitleCell(
        _ cell: UITableViewCell,
        title: String,
        at indexPath: IndexPath,
        myNFTValue: Int,
        selectedNFTValue: Int
    ) {
        var categoryTitle = ""

        switch indexPath.row {
        case 0:
            categoryTitle = (myNFTValue > 0) ? "\(title) (\(myNFTValue))" : title
        case 1:
            categoryTitle = (selectedNFTValue > 0) ? "\(title) (\(selectedNFTValue))" : title
        default:
            categoryTitle = title
        }

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = categoryTitle
            content.textProperties.color = .ypBlack
            content.textProperties.font = .bold17
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = categoryTitle
            cell.textLabel?.textColor = .ypBlack
            cell.textLabel?.font = .bold17
        }
    }
}
