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
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        let basketController = BacketViewController()
        let statisticController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticController.tabBarItem = statisticTabBarItem

        let basketNavController = UINavigationController(rootViewController: basketController)

        viewControllers = [profileController, catalogController, basketNavController, statisticsController]
        view.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .ypBlack
    }
}
