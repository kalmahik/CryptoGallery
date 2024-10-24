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

        let profileNavigationController = createProfileViewController()
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        let basketController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        let statisticController = TestCatalogViewController(servicesAssembly: servicesAssembly) // TODO: change to correct VC
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticController.tabBarItem = statisticTabBarItem
        viewControllers = [profileNavigationController, catalogController, basketController, statisticController]
        view.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .ypBlack
    }

    private func createProfileViewController() -> UINavigationController {
        let profileService = servicesAssembly.profileService
        let nftService = servicesAssembly.myNftService
        let profileRepository = ProfileRepositoryImpl(profileService: profileService)
        let profileRouter = ProfileRouter(profileService: profileService, nftService: nftService)
        let profilePresenter = ProfilePresenter(router: profileRouter, repository: profileRepository)
        let profileController = ProfileViewController(presenter: profilePresenter)
        profilePresenter.view = profileController
        profileRouter.viewController = profileController
        profileController.tabBarItem = profileTabBarItem
        return UINavigationController(rootViewController: profileController)
    }

}
