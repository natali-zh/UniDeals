import UIKit
import SwiftUI

@MainActor
final class MainCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: AppCoordinator?
    private let tabBarController = UITabBarController()
    private var homeCoordinator: HomeCoordinator?
    private var exploreCoordinator: ExploreCoordinator?
    private var mapCoordinator: MapCoordinator?
    private var savedCoordinator: SavedDiscountsCoordinator?

    // MARK: - Computed Properties

    var rootViewController: UIViewController {
        tabBarController
    }

    // MARK: - Methods

    func start() {
        tabBarController.tabBar.tintColor = .colorPrimary
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.viewControllers = makeTabs()
    }

    private func makeTabs() -> [UIViewController] {
        let homeNav = makeNav(title: "მთავარი", icon: "house", selectedIcon: "house.fill")
        homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator?.onSeeAll = { [weak self] in
            self?.tabBarController.selectedIndex = 1
        }
        homeCoordinator?.onShowOnMap = { [weak self] discount in
            self?.showOnMap(discount: discount)
        }
        homeCoordinator?.onLogOut = { [weak self] in
            self?.parentCoordinator?.logOut()
        }
        homeCoordinator?.start()

        let exploreNav = makeNav(title: "აღმოჩენა", icon: "magnifyingglass", selectedIcon: "magnifyingglass")
        exploreCoordinator = ExploreCoordinator(navigationController: exploreNav)
        exploreCoordinator?.onShowOnMap = { [weak self] discount in
            self?.showOnMap(discount: discount)
        }
        exploreCoordinator?.start()

        let cardNav = makeNav(title: "ბარათი", icon: "creditcard", selectedIcon: "creditcard.fill")
        let cardVC = UIHostingController(rootView: CardView())
        cardNav.setViewControllers([cardVC], animated: false)

        let mapNav = makeNav(title: "რუკა", icon: "map", selectedIcon: "map.fill")
        mapCoordinator = MapCoordinator(navigationController: mapNav)
        mapCoordinator?.start()

        let savedNav = makeNav(title: "შენახული", icon: "heart", selectedIcon: "heart.fill")
        savedCoordinator = SavedDiscountsCoordinator(navigationController: savedNav)
        savedCoordinator?.onShowOnMap = { [weak self] discount in
            self?.showOnMap(discount: discount)
        }
        savedCoordinator?.start()

        return [
            homeNav,
            exploreNav,
            cardNav,
            savedNav,
            mapNav
        ]
    }

    private func showOnMap(discount: Discount) {
        tabBarController.selectedIndex = 4
        mapCoordinator?.show(discount: discount)
    }

    private func makeNav(title: String, icon: String, selectedIcon: String) -> UINavigationController {
        let nav = SwipeableNavigationController()
        nav.tabBarItem = UITabBarItem(title: title,
                                      image: UIImage(systemName: icon),
                                      selectedImage: UIImage(systemName: selectedIcon))
        return nav
    }
}
