//
//  Coordinator.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
