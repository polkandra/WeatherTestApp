//
//  AppDelegate.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }
}

