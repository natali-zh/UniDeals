//
//  MainTabCoordinator.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 14.06.26.
//

import UIKit
import SwiftUI

final class MainCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: AppCoordinator?
    private let tabBarController = UITabBarController()
    private var homeCoordinator: HomeCoordinator?
    private var exploreCoordinator: ExploreCoordinator?
    private var mapCoordinator: MapCoordinator?

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
        let homeNav = makeNav(title: "Home", icon: "house", selectedIcon: "house.fill")
        homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator?.onSeeAll = { [weak self] in
            self?.tabBarController.selectedIndex = 1
        }
        homeCoordinator?.start()

        let exploreNav = makeNav(title: "Explore", icon: "magnifyingglass", selectedIcon: "magnifyingglass")
        exploreCoordinator = ExploreCoordinator(navigationController: exploreNav)
        exploreCoordinator?.start()

        // Create navigation controllers for SwiftUI views
        let cardNav = makeNav(title: "Card", icon: "creditcard", selectedIcon: "creditcard.fill")
        let cardVC = UIHostingController(rootView: CardView())
        cardNav.setViewControllers([cardVC], animated: false)

        let mapNav = makeNav(title: "Map", icon: "map", selectedIcon: "map.fill")
        mapCoordinator = MapCoordinator(navigationController: mapNav)
        mapCoordinator?.start()

        let profileNav = makeNav(title: "Account", icon: "person", selectedIcon: "person.fill")
        let profileVC = UIHostingController(rootView: ProfileView())
        profileNav.setViewControllers([profileVC], animated: false)

        return [
            homeNav,
            exploreNav,
            cardNav,
            mapNav,
            profileNav
        ]
    }

    private func makeNav(title: String, icon: String, selectedIcon: String) -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(title: title,
                                      image: UIImage(systemName: icon),
                                      selectedImage: UIImage(systemName: selectedIcon))
        return nav
    }
}
