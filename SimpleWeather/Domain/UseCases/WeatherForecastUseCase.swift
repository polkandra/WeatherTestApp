//
//  WeatherForecastUseCase.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 15.05.2025.
//

import CoreLocation

protocol WeatherForecastUseCase {
    func execute(location: CLLocation, completion: @escaping (Result<WeatherForecastDTO, Error>) -> Void)
}

final class WeatherForecastUseCaseImpl: WeatherForecastUseCase {
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func execute(location: CLLocation, completion: @escaping (Result<WeatherForecastDTO, Error>) -> Void) {
        weatherRepository.fetchHourForecast(location: location, completion: completion)
    }
}

