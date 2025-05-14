//
//  WeatherOverviewViewModel.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import CoreLocation

protocol UpdateWeatherDelegate: AnyObject {
    func updateWeather(model: CurrentWeatherModel)
}

final class WeatherOverviewViewModel {
    
    weak var coordinator: MainCoordinator?
    weak var delegate: UpdateWeatherDelegate?
    private let currentWeatherUseCase: CurrentWeatherUseCase
    private let locationService: LocationService
    private let mapper: WeatherMapper
    
    init(
        currentWeatherUseCase: CurrentWeatherUseCase,
        locationService: LocationService,
        mapper: WeatherMapper
    ) {
        self.currentWeatherUseCase = currentWeatherUseCase
        self.locationService = locationService
        self.mapper = mapper
        setupLocationService()
    }
    
    deinit {
        locationService.stopUpdatingLocation()
    }
}

extension WeatherOverviewViewModel: LocationServiceDelegate {
    
    func didUpdateLocation(_ location: CLLocation) {
        print("📍 Текущее местоположение: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        fetchCurrentWeather(location: location)
    }
    
    func didFailWithError(_ error: Error) {
        print("❌ Ошибка получения локации: \(error.localizedDescription)")
    }
}

private extension WeatherOverviewViewModel {
    
    func setupLocationService() {
        locationService.delegate = self
        locationService.requestLocationAccess()
        locationService.startUpdatingLocation()
    }
    
    func fetchCurrentWeather(location: CLLocation) {
        currentWeatherUseCase.execute(location: location) { result in
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
                self.delegate?.updateWeather(model: self.mapper.currentWeatherModel(currentWeather: currentWeather))
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
