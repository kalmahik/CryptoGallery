//
//  BacketViewController.swift
//  FakeNFT
//
//  Created by Вадим on 12.10.2024.
//

import UIKit

final class BacketViewController: UIViewController, BacketViewProtocol {

    // MARK: - Identifier

    static let cellIdentifier = "NFTCell"

    // MARK: - Public Properties

    var presenter: BacketPresenter?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: BacketViewController.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Private Properties

    private let payButtonTitle = LocalizationKey.basketForPayButton.localized()
    private let sortLabelTitle = LocalizationKey.sortTitle.localized()
    private let sortPriceTitle = LocalizationKey.sortByPrice.localized()
    private let sortRatingTitle = LocalizationKey.sortByRating.localized()
    private let sortNameTitle = LocalizationKey.sortByName.localized()
    private let sortCloseTitle = LocalizationKey.close.localized()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "light")
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()

    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16
        view.heightAnchor.constraint(equalToConstant: 76).isActive = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.textColor = .ypBlack
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.textColor = .ypGreenUniversal
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return label
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(payButtonTitle, for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .bold17
        button.layer.cornerRadius = UIConstants.CornerRadius.medium16
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftCountLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelsStackView, payButton])
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
        setupNavigationBar()
        presenter = BacketPresenter(view: self)
        presenter?.loadNFTData()
    }

    // MARK: - Public Methods

    func updateNFTCountLabel(with count: Int) {
        nftCountLabel.text = "\(count) NFT"
    }

    func updateTotalPriceLabel(with totalPrice: Double) {
        priceLabel.text = String(format: "%.2f ETH", totalPrice)
    }

    // MARK: - Actions

    @objc func didTapFilterButton() {
        let alert = UIAlertController(title: sortLabelTitle, message: nil, preferredStyle: .actionSheet)
        let priceAction = UIAlertAction(title: sortPriceTitle, style: .default) { _ in
            self.presenter?.saveSortOption(.price)
            self.presenter?.sortNFTItems(by: .price)
            self.tableView.reloadData() }
        let ratingAction = UIAlertAction(title: sortRatingTitle, style: .default) { _ in
            self.presenter?.saveSortOption(.rating)
            self.presenter?.sortNFTItems(by: .rating)
            self.tableView.reloadData() }
        let titleAction = UIAlertAction(title: sortNameTitle, style: .default) { _ in
            self.presenter?.saveSortOption(.name)
            self.presenter?.sortNFTItems(by: .name)
            self.tableView.reloadData() }
        alert.addAction(priceAction)
        alert.addAction(ratingAction)
        alert.addAction(titleAction)
        alert.addAction(UIAlertAction(title: sortCloseTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func payButtonTapped() {
        presenter?.payButtonTapped()
    }
}

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
