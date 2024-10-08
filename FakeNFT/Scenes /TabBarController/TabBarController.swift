import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let  profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 1
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.basket", comment: ""), // TODO: change to correct icon
        image: UIImage(systemName: "trash"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        let basketController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        let statisticsController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem
        viewControllers = [profileController, catalogController, basketController, statisticsController]
        view.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .black // TODO: change to correct color
    }
}
