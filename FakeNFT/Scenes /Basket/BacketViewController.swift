//
//  BacketViewController.swift
//  FakeNFT
//
//  Created by Вадим on 12.10.2024.
//

import UIKit

<<<<<<< HEAD
final class BacketViewController: UIViewController, BacketViewProtocol {

    // MARK: - Identifier

    static let cellIdentifier = "NFTCell"

    // MARK: - Public Properties

    var presenter: BacketPresenter?
=======
final class BacketViewController: UIViewController {
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760

    // MARK: - Private Properties

    private let payButtonTitle = LocalizationKey.basketForPayButton.localized()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "light")
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlack
        return button
    }()

<<<<<<< HEAD
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: BacketViewController.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

=======
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 76).isActive = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

<<<<<<< HEAD
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

=======
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(payButtonTitle, for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .bold17
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()

<<<<<<< HEAD
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
=======
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [payButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
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
<<<<<<< HEAD
        presenter = BacketPresenter(view: self)
        presenter?.loadNFTData()
=======
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
    }

    // MARK: - Setup

    private func setupUI() {
<<<<<<< HEAD
        [filterButton, tableView, customView].forEach {
=======
        [customView, filterButton].forEach {
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [stackView].forEach {
            customView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),

<<<<<<< HEAD
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: customView.topAnchor),

=======
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
        ])
    }
<<<<<<< HEAD

    func updateNFTCountLabel(with count: Int) {
        nftCountLabel.text = "\(count) NFT"
    }

    func updateTotalPriceLabel(with totalPrice: Double) {
        priceLabel.text = String(format: "%.2f ETH", totalPrice)
    }
=======
>>>>>>> a65737ff5e1103856d28624b412cf159fdadd760
}
