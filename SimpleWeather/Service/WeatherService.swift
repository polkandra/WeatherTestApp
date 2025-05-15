//
//  WeatherOverviewService.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import CoreLocation

protocol WeatherService {
    func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeatherDTO, Error>) -> Void)
    func fetchHourForecast(location: CLLocation, completion: @escaping (Result<WeatherForecastDTO, Error>) -> Void)
}

final class WeatherServiceImplementation: WeatherService {
    func fetchCurrentWeather(location: CLLocation, completion: @escaping (Result<CurrentWeatherDTO, Error>) -> Void) {
        NetworkClient.shared.request(
            urlString: Constants.currentWeatherUrl,
            queryParams: [
                "q": " \(location.coordinate.latitude),\(location.coordinate.longitude)",
                "key": "\(Constants.apiKey)"
            ],
            responseType: CurrentWeatherDTO.self
        ) { result in
            switch result {
            case .success(let currentWeater):
                completion(.success(currentWeater))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchHourForecast(location: CLLocation, completion: @escaping (Result<WeatherForecastDTO, Error>) -> Void) {
        NetworkClient.shared.request(
            urlString: Constants.forecastWeatherUrl,
            queryParams: [
                "key": "\(Constants.apiKey)",
                "q": " \(location.coordinate.latitude),\(location.coordinate.longitude)",
                "days": "7"
            ],
            responseType: WeatherForecastDTO.self
        ) { result in
            switch result {
            case .success(let weatherForecast):
                completion(.success(weatherForecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
