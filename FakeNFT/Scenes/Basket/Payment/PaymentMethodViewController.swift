//
//  PaymentMethodViewController.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class PaymentMethodViewController: UIViewController, PaymentMethodViewProtocol {

    // MARK: - Identifier

    static let cellIdentifier = "CurrencyCell"

    // MARK: - Private Properties

    private var presenter: PaymentMethodPresenterProtocol?
    private var selectedIndexPath: IndexPath?

    private let paymentTitleLabel = LocalizationKey.basketTitle.localized()
    private let payButtonTitle = LocalizationKey.basketForPayButton.localized()
    private let descriptionTitleLabel = LocalizationKey.basketAgreeDescription.localized()
    private let userTitleLabel = LocalizationKey.basketUserAgree.localized()
    private let currencies: [CurrencyType] = CurrencyType.allCases

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = paymentTitleLabel
        label.font = .bold17
        label.textColor = .ypBlack
        return label
    }()

    private lazy var cryptoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CurrencyCell.self,
            forCellWithReuseIdentifier: PaymentMethodViewController.cellIdentifier)
        return collectionView
    }()

    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16
        view.heightAnchor.constraint(equalToConstant: 186).isActive = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private lazy var agreeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = descriptionTitleLabel
        label.font = .regular13
        label.textColor = .ypBlack
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()

    private lazy var agreeUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(userTitleLabel, for: .normal)
        button.titleLabel?.font = .regular13
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(agreeUserButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [agreeDescriptionLabel, agreeUserButton])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(payButtonTitle, for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .bold17
        button.layer.cornerRadius = UIConstants.CornerRadius.medium16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        setupConstraints()
        setupBackButton()
        setupNavigationBarTitle()
        presenter = PaymentMethodPresenter(view: self, viewController: self)
    }

    // MARK: - Public Methods

    func displayPaymentSuccess() {
        presenter?.didTapPayButton()
    }

    func displayAgreementConfirmation() {
        presenter?.didTapAgreeButton()
    }

    // MARK: - Actions

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func agreeUserButtonTapped() {
        presenter?.didTapAgreeButton()
    }

    @objc func payButtonTapped() {
        presenter?.didTapPayButton()
    }
}

// MARK: - Setup

extension PaymentMethodViewController {
    func setupUI() {
        [cryptoCollectionView, customView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [stackView, payButton].forEach {
            customView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            cryptoCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            cryptoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cryptoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cryptoCollectionView.bottomAnchor.constraint(equalTo: customView.topAnchor),

            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            payButton.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50)
        ])
    }

    private func setupNavigationBarTitle() {
        navigationItem.titleView = titleLabel
    }

    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        let backImage = UIImage(named: "back")
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .ypBlack
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
}

// MARK: - UICollectionViewDataSource

extension PaymentMethodViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return currencies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodViewController.cellIdentifier,
            for: indexPath) as? CurrencyCell else {
            return UICollectionViewCell()
        }
        let currency = currencies[indexPath.item]
        cell.configure(with: currency)
        let isSelected = (indexPath == selectedIndexPath)
        cell.setSelected(isSelected)
        cell.delegate = self
        return cell
    }
}

// MARK: - CurrencyCellDelegate

extension PaymentMethodViewController: CurrencyCellDelegate {
    func didSelectCurrency(_ currency: CurrencyType) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = cryptoCollectionView.cellForItem(at: previousIndexPath) as? CurrencyCell
            previousCell?.setSelected(false)
        }
        if let index = currencies.firstIndex(of: currency),
           let currentCell = cryptoCollectionView.cellForItem(
            at: IndexPath(item: index, section: 0)) as? CurrencyCell {
            currentCell.setSelected(true)
            selectedIndexPath = IndexPath(item: index, section: 0)
        }
        presenter?.updateSelectedCurrency(currency)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentMethodViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 16
        let interItemSpacing: CGFloat = 7
        let availableWidth = collectionView.frame.width - padding * 2 - interItemSpacing
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 46)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
}
