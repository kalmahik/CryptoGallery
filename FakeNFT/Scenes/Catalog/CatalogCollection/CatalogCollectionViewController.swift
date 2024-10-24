//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 12.10.2024.
//

import UIKit

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadCatalog()
    func showindicator()
    func hideIndicator()
}

final class CatalogViewController: UIViewController, ErrorView {

    // MARK: - Private Properties

    private var presenter: CatalogCollectionPresenterProtocol

    // MARK: - UI Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        tableView.register(CellTableCollectionNFT.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var activityIndicatorUI: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Initializers

    init(presenter: CatalogCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        setupLayout()
        setNavigationItem()
        presenter.viewDidLoad()
    }

    // MARK: - didTapSortTypeMenu

    @objc private func openSortTypeMenu() {
        let textLocalizationSorting = LocalizationKey.sortTitle.localized()
        let actionSheet = UIAlertController(title: textLocalizationSorting, message: nil, preferredStyle: .actionSheet)

        let textLocalizationName = LocalizationKey.sortByName.localized()
        let nameButton = UIAlertAction(title: textLocalizationName, style: .default) { _ in
            self.presenter.didSelectSortType(.name)
        }

        let textLocalizationQuantity = LocalizationKey.sortByQuantity.localized()
        let countButton = UIAlertAction(title: textLocalizationQuantity, style: .default) { _ in
            self.presenter.didSelectSortType(.quantityNft)
        }

        let textLocalizationClouse = LocalizationKey.close.localized()
        let cancelButton = UIAlertAction(title: textLocalizationClouse, style: .cancel)

        actionSheet.addAction(nameButton)
        actionSheet.addAction(countButton)
        actionSheet.addAction(cancelButton)

        present(actionSheet, animated: true)
    }
}

// MARK: - Extension: UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCollectionCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellTableCollectionNFT = tableView.dequeueReusableCell()
        let cover = presenter.getCollectionCover(indexPath.row)
        let name = presenter.getCollectionName(indexPath.row)
        let quantity = presenter.getCollectionQuantityNft(indexPath.row)
        cell.configCell(cover, name, quantity)
        return cell
    }
}

// MARK: - Extension: UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let сollectionNFTViewController = CollectionNFTViewController()
        сollectionNFTViewController.modalPresentationStyle = .fullScreen
        self.present(сollectionNFTViewController, animated: true)
    }
}

// MARK: - CatalogViewControllerProtocol

extension CatalogViewController: CatalogViewControllerProtocol {

    func reloadCatalog() {
        tableView.reloadData()
    }

    func showindicator() {
        showLoading()
    }

    func hideIndicator() {
        hideLoading()
    }
}

// MARK: - LoadingView

extension CatalogViewController: LoadingView {

    var activityIndicator: UIActivityIndicatorView {
        return self.activityIndicatorUI
    }
}

// MARK: - Extension: View Layout

extension CatalogViewController {

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}

// MARK: - Extension: Navigation Item

extension CatalogViewController {
    func setNavigationItem() {
        let sortButton = UIBarButtonItem(image: UIImage(named: "light"), style: .plain, target: self, action: #selector(openSortTypeMenu))
        sortButton.tintColor = .ypBlack
        self.navigationItem.rightBarButtonItem = sortButton
    }
}
