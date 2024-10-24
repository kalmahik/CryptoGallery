import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let  profileTabBarItem = UITabBarItem(
        title: LocalizationKey.tabProfile.localized(),
        image: UIImage(named: "profile"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: LocalizationKey.tabCatalog.localized(),
        image: UIImage(named: "catalog"),
        tag: 1
    )

    private let basketTabBarItem = UITabBarItem(
        title: LocalizationKey.tabBasket.localized(),
        image: UIImage(named: "basket"),
        tag: 2
    )

    private let statisticTabBarItem = UITabBarItem(
        title: LocalizationKey.tabStatistic.localized(),
        image: UIImage(named: "statistic"),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        let catalogController = createCatalogViewController()
        let basketController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        let statisticController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticController.tabBarItem = statisticTabBarItem
        viewControllers = [profileController, catalogController, basketController, statisticController]
        view.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .ypBlack
    }

    private func createCatalogViewController() -> UINavigationController {
        let catalogCollectionModel = CatalogCollectionModel(catalogService: servicesAssembly.catalogService)
        let catalogCollectionPresenter = CatalogCollectionPresenter(model: catalogCollectionModel)
        let catalogView = CatalogViewController(presenter: catalogCollectionPresenter, servicesAssembly: servicesAssembly)
        catalogCollectionModel.presenter = catalogCollectionPresenter
        catalogCollectionPresenter.view = catalogView
        return catalogView.wrapWithNavigationController()
    }
}
