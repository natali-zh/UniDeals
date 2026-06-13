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
    
    //MARK: - Computed Properties
    
    var rootViewController: UIViewController {
        tabBarController
    }
    
    //MARK: - Methods
    
    func start() {
        tabBarController.tabBar.tintColor = .colorPrimary
        tabBarController.viewControllers = makeTabs()
    }
    
    private func makeTabs() -> [UIViewController] {
        [
            createTab(root: UIHostingController(rootView: HomeView()),
                      title: "Home",
                      icon: "house",
                      selectedIcon: "house.fill"),
            
            createTab(root: UIHostingController(rootView: ExploreView()),
                      title: "Explore",
                      icon: "magnifyingglass",
                      selectedIcon: "magnifyingglass"),
            
            createTab(root: UIHostingController(rootView: CardView()),
                      title: "Card",
                      icon: "creditcard",
                      selectedIcon: "creditcard.fill"),
            
            createTab(root: UIHostingController(rootView: MapView()),
                      title: "Map",
                      icon: "map",
                      selectedIcon: "map.fill"),
            
            createTab(root: UIHostingController(rootView: ProfileView()),
                      title: "Account",
                      icon: "person",
                      selectedIcon: "person.fill"),
        ]
    }
    
    private func createTab(root: UIViewController, title: String, icon: String, selectedIcon: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: icon),
            selectedImage: UIImage(systemName: selectedIcon)
        )
        return navigationController
    }
}
