//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import UIKit

protocol MyNftProtocol: AnyObject {
    func reloadData()
}

final class MyNftViewController: UIViewController {

    // MARK: - Public Properties

    private let presenter: MyNftPresenterProtocol

    // MARK: - Provate Properties

    private lazy var placeholderView: Placeholder = {
        let placeholder = Placeholder(text: LocalizationKey.profMyNftPlaceholder.localized())
        placeholder.isHidden = true
        return placeholder
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNftCell.self)
        return tableView
    }()

    // MARK: - Init

    init(presenter: MyNftPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        checkForData()
        presenter.viewDidLoad()
    }

    // MARK: - Private Methods

    private func checkForData() {
        let hasData = presenter.nfts.count > 0
        placeholderView.isHidden = !hasData
        tableView.isHidden = hasData
    }
}

// MARK: - Layout

extension MyNftViewController {
    private func setupUI() {
        [tableView, placeholderView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        tableView.constraintEdges(to: view)
        placeholderView.constraintCenters(to: view)
    }
}

// MARK: - UITableViewDelegate

extension MyNftViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            presenter.loadMoreNftsIfNeeded(currentItemIndex: tableView.indexPathsForVisibleRows?.last?.row ?? 0)
        }
    }
}

// MARK: - UITableViewDataSource

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNftCell = tableView.dequeueReusableCell()
        let nft = presenter.nfts[indexPath.row]
        cell.configure(with: nft)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - MyNftProtocol

extension MyNftViewController: MyNftProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

