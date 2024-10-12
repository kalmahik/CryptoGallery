//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 12.10.2024.
//

import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Public Properties

    let servicesAssembly: ServicesAssembly

    // MARK: - UI Components

    private lazy var sortedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "light")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(openSortTypeMenu), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(CellTableCollectionNFT.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Initializers

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly // TODO: - Пока не знаю что с этим делать
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLayout()
    }

    // MARK: - IBActions

    @IBAction private func openSortTypeMenu() {
        let textLocalizationSorting = LocalizationKey.sortTitle.localized()
        let actionSheet = UIAlertController(title: textLocalizationSorting, message: nil, preferredStyle: .actionSheet)

        let textLocalizationName = LocalizationKey.sortByName.localized()
        let nameButton = UIAlertAction(title: textLocalizationName, style: .default) { _ in
            // TODO: - Sorting by name
        }

        let textLocalizationQuantity = LocalizationKey.sortByQuantity.localized()
        let countButton = UIAlertAction(title: textLocalizationQuantity, style: .default) { _ in
            // TODO: - Sorting by NFT quantity
        }

        let textLocalizationClouse = LocalizationKey.close.localized()
        let cancelButton = UIAlertAction(title: textLocalizationClouse, style: .cancel)

        actionSheet.addAction(nameButton)
        actionSheet.addAction(countButton)
        actionSheet.addAction(cancelButton)

        present(actionSheet, animated: true)
    }

    // MARK: - View Layout

    private func setupLayout() {
        view.addSubview(sortedButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            sortedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortedButton.heightAnchor.constraint(equalToConstant: 42),
            sortedButton.widthAnchor.constraint(equalToConstant: 42),

            tableView.topAnchor.constraint(equalTo: sortedButton.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - Extension: UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellTableCollectionNFT = tableView.dequeueReusableCell()

//        collectionNFTCell.configCell(<#T##cover: UIImage##UIImage#>, <#T##name: String##String#>, <#T##quantity: Int##Int#>)

        return cell
    }
}

// MARK: - Extension: UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {

}
