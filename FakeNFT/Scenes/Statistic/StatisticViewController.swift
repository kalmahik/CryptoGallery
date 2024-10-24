import UIKit

final class StatisticViewController: UIViewController, StatisticViewProtocol {
    private var presenter: StatisticPresenterProtocol
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView  = UITableView()
        tableView.register(StatisticCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private lazy var loading: UIActivityIndicatorView = {
        let activityIndicator  = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "light")
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Initializers
    
    init(presenter: StatisticPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    // MARK: - Public Methods
    
    func updateStatistic() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func startLoading() {
        loading.startAnimating()
    }
    
    func stopLoading() {
        loading.stopAnimating()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        presenter.loadStatistic()
    }
    
    @objc func didTapFilterButton(sender: AnyObject) {
        let alert = UIAlertController(title: LocalizationKey.sortTitle.localized(), message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: LocalizationKey.sortByNameAlt.localized(), style: .default , handler:{ _ in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKey.sortByRating.localized(), style: .default , handler:{ _ in
            print("User click Edit button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

// MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.openProfile(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.loadNextStatistic(indexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getUserList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statistic = presenter.getUserList()[indexPath.row]
        let cell: StatisticCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        cell.setupCell(statistic: statistic, place: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 80 }
}

// MARK: - applyConstraints && addSubViews

extension StatisticViewController {
    // MARK: - Configure
    
    internal func setupView() {
        view.backgroundColor = .ypWhite
        view.setupView(tableView)
        view.setupView(loading)
        tableView.constraintEdges(to: view)
        tableView.addSubview(refreshControl)
        loading.constraintCenters(to: view)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    internal func setupConstraints() {
        NSLayoutConstraint.activate([])
    }
}

extension StatisticViewController {
    func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "light"))
        let item = filterButton.toBarButtonItem()
        self.navigationItem.rightBarButtonItem = item
    }
}
