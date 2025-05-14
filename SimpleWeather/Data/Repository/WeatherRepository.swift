//
//  WeatherRepository.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import CoreLocation

protocol WeatherRepository {
    func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeatherDTO, Error>) -> Void)
}

final class WeatherRepositoryImplementation: WeatherRepository {
    
    let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeatherDTO, Error>) -> Void) {
        weatherService.fetchCurrentWeather(location: location, completion: completion)
    }
}
