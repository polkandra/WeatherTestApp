//
//  MainCoordinator.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {}

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = WeatherRepositoryImplementation(weatherService: WeatherServiceImplementation())
        let viewModel = WeatherOverviewViewModel(
            weatherForecastUseCase: WeatherForecastUseCaseImpl(weatherRepository: repository),
            locationService: LocationService(),
            mapper: WeatherMapperImpl()
        )
       
        viewModel.coordinator = self
        let viewController = WeatherOverviewViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: MainCoordinatorDelegate {}
