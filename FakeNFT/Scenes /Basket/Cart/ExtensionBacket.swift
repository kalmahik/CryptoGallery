//
//  ExtensionBacket.swift
//  FakeNFT
//
//  Created by Вадим on 12.10.2024.
//

import UIKit

// MARK: - Setup

extension BacketViewController {
    func setupUI() {
        [tableView, customView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [stackView].forEach {
            customView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: customView.topAnchor),

            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
        ])
    }

    func setupNavigationBar() {
        let filterBarButtonItem = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItem = filterBarButtonItem
    }
}

// MARK: - UITableViewDataSource

extension BacketViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter?.getNFTItemsCount() ?? 0
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
        if let nftItem = presenter?.getNFTItem(at: indexPath.row) {
            cell.configure(with: nftItem)
        }
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
