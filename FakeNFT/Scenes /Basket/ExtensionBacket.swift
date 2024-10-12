//
//  ExtensionBacket.swift
//  FakeNFT
//
//  Created by Вадим on 12.10.2024.
//

import UIKit

// MARK: - UITableViewDataSource

extension BacketViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BacketViewController.cellIdentifier,
            for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        let randomRating = Int.random(in: 1...5)
        cell.configure(withRating: randomRating)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BacketViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 140
    }
}
