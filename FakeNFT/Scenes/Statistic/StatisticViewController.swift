import UIKit

final class StatisticViewController: UIViewController, StatisticViewProtocol {
    private let servicesAssembly: ServicesAssembly
    private var presenter: StatisticPresenterProtocol?
    private var users: [Statistic] = []

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

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        let model = StatisticModel(statisticService: servicesAssembly.statisticService)
        presenter = StatisticPresenter(view: self, model: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func updateStatistic(_ users: [Statistic]) {
        self.users = users
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.openProfile(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.loadNextStatistic(indexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statistic = users[indexPath.row]
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
        tableView.constraintEdges(to: view)
    }

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension StatisticViewController {
    func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "light"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
