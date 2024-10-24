//
//  CollectionNFTViewController.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import UIKit

protocol CollectionNFTViewControllerProtocol: AnyObject {
    func reloadCollection()
    func showindicator()
    func hideIndicator()
}

final class CollectionNFTViewController: UIViewController {

    // MARK: - Private Properties

    private var presenter: CollectionNFTPresenterProtocol

    // MARK: - UI Components

    lazy var collectionNFTs: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NFTCell.self)
        collectionView.registerHeader(NFTHeader.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    private lazy var activityIndicatorUI: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Initializers

    init(presenter: CollectionNFTPresenterProtocol) {
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
        presenter.viewDidLoad()
        view.backgroundColor = .background
        setNavigationItem()
        setupUI()
    }

    // MARK: - Actions

    @objc private func closeUserButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionNFTViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getCountNFTs()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nft = presenter.getNFT(indexPath.row)
        let like = presenter.gerStatusLike(indexPath.row)
        cell.configureCell(nft, like)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: NFTHeader = collectionView.dequeueReusableHeader(indexPath: indexPath)
        let collection = presenter.getCollection()
        header.configureHeader(collection)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16 * 2 - 10 * 2) / 3
        let height = width + 56 + 20 + 8
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let headerView = NFTHeader()
        let collection = presenter.getCollection()
        headerView.configureHeader(collection)
        let height = headerView.calculateHeight(for: width)

        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionNFTViewController: UICollectionViewDelegate {
}

// MARK: - CollectionNFTViewControllerProtocol

extension CollectionNFTViewController: CollectionNFTViewControllerProtocol {
    func reloadCollection() {
        collectionNFTs.reloadData()
    }

    func showindicator() {
        showLoading()
    }

    func hideIndicator() {
        hideLoading()
    }
}

// MARK: - LoadingView

extension CollectionNFTViewController: LoadingView {

    var activityIndicator: UIActivityIndicatorView {
        return self.activityIndicatorUI
    }
}

// MARK: - Extension: View Layout

extension CollectionNFTViewController {
    private func setupUI() {
        view.addSubview(collectionNFTs)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            collectionNFTs.topAnchor.constraint(equalTo: view.topAnchor),
            collectionNFTs.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionNFTs.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionNFTs.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 3 * 2)
        ])
    }
}

// MARK: - Extension: Navigation Item

extension CollectionNFTViewController {
    func setNavigationItem() {
        let image = UIImage(systemName: "chevron.backward")
        let sortButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeUserButtonTapped))
        sortButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = sortButton
    }
}
