//
//  WeatherRepository.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import CoreLocation

protocol WeatherRepository {
    func fetchHourForecast(location: CLLocation, completion: @escaping (Result<WeatherForecastDTO, Error>) -> Void)
}

final class WeatherRepositoryImplementation: WeatherRepository {
    
    let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchHourForecast(location: CLLocation, completion: @escaping (Result<WeatherForecastDTO, Error>) -> Void) {
        weatherService.fetchHourForecast(location: location, completion: completion)
    }
}
