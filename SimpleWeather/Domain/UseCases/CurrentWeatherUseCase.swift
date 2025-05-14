//
//  CurrentWeatherUseCase.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import CoreLocation

protocol CurrentWeatherUseCase {
    func execute(location: CLLocation, completion: @escaping (Result<CurrentWeatherDTO, Error>) -> Void)
}

final class CurrentWeatherUseCaseImpl: CurrentWeatherUseCase {
    let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func execute(location: CLLocation, completion: @escaping (Result<CurrentWeatherDTO, Error>) -> Void) {
        weatherRepository.fetchCurrentWeather(location: location, completion: completion)
    }
}
