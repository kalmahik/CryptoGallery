//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import UIKit

protocol MyNftProtocol: AnyObject {
    func reloadData()
    func reloadRow(at index: Int)
    func cellForRow(at index: Int) -> MyNftCell?
    func showError(message: String)
}

final class MyNftViewController: UIViewController {

    // MARK: - Public Properties

    var shimmerViews: [ShimmerView] = []
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Private Properties

    private let presenter: MyNftPresenterProtocol

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

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
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
        setupNavigationBar()
        presenter.viewDidLoad()
    }

    // MARK: - Private Methods

    private func checkForData() {
        let hasData = presenter.nfts.count > 0
        placeholderView.isHidden = !hasData
        tableView.isHidden = hasData
    }

    private func setupNavigationBar() {
        title = LocalizationKey.profMyNft.localized()

        let sortButton = UIBarButtonItem(
            image: UIImage(named: "light"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )

        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        [sortButton, backButton].forEach {
            $0.tintColor = .ypBlack
        }

        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sortButton
    }
}

// MARK: - Layout

extension MyNftViewController {
    private func setupUI() {
        [tableView, placeholderView, activityIndicator].forEach {
            view.setupView($0)
        }
        [placeholderView, activityIndicator].forEach {
            $0.constraintCenters(to: view)
        }
        tableView.refreshControl = refreshControl
        tableView.constraintEdges(to: view)
    }
}

// MARK: - UITableViewDelegate

extension MyNftViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.isLoading ? shimmerViews.count : presenter.nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.isLoading {
            return createShimmerViewCell()
        } else {
            guard indexPath.row < presenter.nfts.count else {
                return UITableViewCell()
            }

            let cell: MyNftCell = tableView.dequeueReusableCell()
            let nft = presenter.nfts[indexPath.row]

            let isLiked = presenter.isLiked(nft: nft)
            cell.configure(with: nft, isLiked: isLiked) { [weak self] likedNft in
                self?.presenter.toggleLike(for: likedNft)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - Actions

extension MyNftViewController {
    @objc
    private func sortButtonTapped() {
        showSortActionSheet()
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func handleRefresh() {
        presenter.refreshData()
    }
}

// MARK: - Sort

extension MyNftViewController {

    private func showSortActionSheet() {
        let alertController = UIAlertController(
            title: LocalizationKey.sortTitle.localized(),
            message: nil,
            preferredStyle: .actionSheet
        )

        let sortByPriceAction = UIAlertAction(
            title: LocalizationKey.sortByPrice.localized(),
            style: .default
        ) { [weak self] _ in
            self?.presenter.setSortType(.price)
        }

        let sortByRatingAction = UIAlertAction(
            title: LocalizationKey.sortByRating.localized(),
            style: .default
        ) { [weak self] _ in
            self?.presenter.setSortType(.rating)
        }

        let sortByNameAction = UIAlertAction(
            title: LocalizationKey.sortByName.localized(),
            style: .default
        ) { [weak self] _ in
            self?.presenter.setSortType(.name)
        }

        let cancelAction = UIAlertAction(
            title: LocalizationKey.actionClose.localized(),
            style: .cancel,
            handler: nil
        )

        [sortByPriceAction, sortByRatingAction, sortByNameAction, cancelAction].forEach {
            alertController.addAction($0)
        }

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Shimmer Methods

extension MyNftViewController {

    private func createShimmerViewCell() -> UITableViewCell {
        let shimmerCell = UITableViewCell()

        let shimmerView = ShimmerView()
        shimmerView.applyCornerRadius(.medium16)
        shimmerCell.contentView.setupView(shimmerView)

        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(
                equalTo: shimmerCell.contentView.topAnchor,
                constant: UIConstants.Insets.small8
            ),
            shimmerView.bottomAnchor.constraint(
                equalTo: shimmerCell.contentView.bottomAnchor,
                constant: -UIConstants.Insets.small8
            ),
            shimmerView.leadingAnchor.constraint(
                equalTo: shimmerCell.contentView.leadingAnchor,
                constant: UIConstants.Insets.medium16
            ),
            shimmerView.trailingAnchor.constraint(
                equalTo: shimmerCell.contentView.trailingAnchor,
                constant: -UIConstants.Insets.medium16
            ),
            shimmerView.heightAnchor.constraint(
                equalToConstant: UIConstants.Heights.height108
            )
        ])

        shimmerView.startShimmer()
        return shimmerCell
    }

    private func showShimmer() {
        presenter.isLoading = true
        shimmerViews = createShimmerViews(count: 5)
        tableView.reloadData()
    }

    private func hideShimmer() {
        presenter.isLoading = false
        shimmerViews.removeAll()
        tableView.reloadData()
    }

    private func createShimmerViews(count: Int) -> [ShimmerView] {
        var views = [ShimmerView]()
        for _ in 0..<count {
            let shimmerView = ShimmerView()
            views.append(shimmerView)
        }
        return views
    }
}

// MARK: - LoadingView

extension MyNftViewController: LoadingView {

    func showLoadingIndicator() {
        showLoading()
    }

    func hideLoadingIndicator() {
        hideLoading()
    }
}

// MARK: - MyNftProtocol

extension MyNftViewController: MyNftProtocol {

    func cellForRow(at index: Int) -> MyNftCell? {
        let indexPath = IndexPath(row: index, section: 0)
        return tableView.cellForRow(at: indexPath) as? MyNftCell
    }

    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func reloadData() {
        if presenter.isLoading {
            showLoadingIndicator()
            showShimmer()
        } else {
            hideLoadingIndicator()
            hideShimmer()
        }
        
        tableView.reloadData()
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: LocalizationKey.errorTitle.localized(),
                                                message: message,
                                                preferredStyle: .alert)
        let retryAction = UIAlertAction(title: LocalizationKey.errorRepeat.localized(),
                                        style: .default) { [weak self] _ in
            self?.presenter.refreshData()
        }
        let cancelAction = UIAlertAction(title: LocalizationKey.actionClose.localized(),
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}