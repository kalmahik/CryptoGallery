//
//  CollectionNFTViewController.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import UIKit

protocol CollectionNFTViewControllerProtocol {
}

final class CollectionNFTViewController: UIViewController {

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(closeUserButtonTapped), for: .touchUpInside)
        return button
    }()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
    }

    // MARK: - Actions

    @objc private func closeUserButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension CollectionNFTViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: NFTHeader = collectionView.dequeueReusableHeader(indexPath: indexPath)

        return header
    }
}

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
        let height = headerView.calculateHeight(for: width)

        return CGSize(width: width, height: height)
    }
}

extension CollectionNFTViewController: UICollectionViewDelegate {

}

// MARK: - Extension: View Layout

extension CollectionNFTViewController {
    private func setupUI() {
        view.addSubview(collectionNFTs)
        view.addSubview(closeButton)

        collectionNFTs.constraintEdges(to: view)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
        closeButton.heightAnchor.constraint(equalToConstant: 24),
        closeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
