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

    private var isLoading = true

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
        showShimmer()
        checkForData()
        setupNavigationBar()
        presenter.viewDidLoad()
        showLoadingIndicator()
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
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        tableView.constraintEdges(to: view)
        placeholderView.constraintCenters(to: view)
        activityIndicator.constraintCenters(to: view)
    }
}

// MARK: - UITableViewDelegate

extension MyNftViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        guard !presenter.allDataLoaded else {
            if !presenter.isLoading {
                presenter.isLoading = true
            }
            return
        }

        if offsetY > contentHeight - height - 100, !presenter.isLoading {
            presenter.loadMoreNftsIfNeeded(currentItemIndex: tableView.indexPathsForVisibleRows?.last?.row ?? 0)
        }
    }
}

// MARK: - UITableViewDataSource

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? shimmerViews.count : presenter.nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            return createShimmerViewCell()
        } else {
            let cell: MyNftCell = tableView.dequeueReusableCell()
            let nft = presenter.nfts[indexPath.row]

            cell.configure(with: nft, isLiked: presenter.isLiked(nft: nft)) { [weak self] likedNft in
                self?.presenter.toggleLike(for: likedNft)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - MyNftProtocol

extension MyNftViewController: MyNftProtocol {
    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func reloadData() {
        hideLoadingIndicator()
        hideShimmer()
        tableView.reloadData()
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
        shimmerView.layer.cornerRadius = UIConstants.CornerRadius.medium16
        shimmerView.clipsToBounds = true
        shimmerView.translatesAutoresizingMaskIntoConstraints = false

        shimmerCell.contentView.addSubview(shimmerView)

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
        isLoading = true
        shimmerViews = createShimmerViews(count: 5)
        tableView.reloadData()
    }

    private func hideShimmer() {
        isLoading = false
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
