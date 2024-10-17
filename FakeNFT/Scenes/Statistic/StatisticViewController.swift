import UIKit

final class StatisticViewController: UIViewController {
    let servicesAssembly: ServicesAssembly

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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setNavigationItem()
        servicesAssembly.statisticService.sendStatisticGetRequest { result in
            print(result)
        }
    }
}

// MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        viewModel.didSelectRowAt(indexPath: indexPath)
//    }
}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 99
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let statistic = statistic[indexPath.row]
        let cell: StatisticCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        cell.setupCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 80 }
}

// MARK: - applyConstraints && addSubViews

extension StatisticViewController {
    // MARK: - Configure

    private func setupView() {
        view.backgroundColor = .ypWhite
        view.setupView(tableView)
        tableView.constraintEdges(to: view)
    }

    private func setupConstraints() {
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
