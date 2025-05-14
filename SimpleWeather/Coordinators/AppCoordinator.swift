//
//  AppCoordinator.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import UIKit

class AppCoordinator: Coordinator {
   
    var window: UIWindow
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showMainFlow()
    }

    func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
