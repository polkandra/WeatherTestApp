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
    var hoursDataSource: [HourForecastWeatherModel] = []
    private let currentWeatherUseCase: CurrentWeatherUseCase
    private let weatherForecastUseCase: WeatherForecastUseCase
    private let locationService: LocationService
    private let mapper: WeatherMapper
    
    init(
        currentWeatherUseCase: CurrentWeatherUseCase,
        weatherForecastUseCase: WeatherForecastUseCase,
        locationService: LocationService,
        mapper: WeatherMapper
    ) {
        self.currentWeatherUseCase = currentWeatherUseCase
        self.weatherForecastUseCase = weatherForecastUseCase
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
       // fetchCurrentWeather(location: location)
        fetchHourForecast(location: location)
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
    
   /* func fetchCurrentWeather(location: CLLocation) {
        currentWeatherUseCase.execute(location: location) { result in
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
                self.delegate?.updateWeather(model: self.mapper.currentWeatherModel(weatherForecast: currentWeather))
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    } */
    
    func fetchHourForecast(location: CLLocation) {
        weatherForecastUseCase.execute(location: location) { result in
            switch result {
            case .success(let forecast):
                let currentWeather = self.mapper.currentWeatherModel(weatherForecast: forecast)
                self.hoursDataSource = self.mapper.hourWeatherModel(weatherForecast: forecast)
                self.delegate?.updateWeather(model: currentWeather)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
