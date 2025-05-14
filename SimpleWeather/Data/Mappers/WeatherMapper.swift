//
//  WeatherMapper.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

protocol WeatherMapper {
    func currentWeatherModel(currentWeather: CurrentWeatherDTO) -> CurrentWeatherModel
}

final class WeatherMapperImpl: WeatherMapper {
    func currentWeatherModel(currentWeather: CurrentWeatherDTO) -> CurrentWeatherModel {
        return CurrentWeatherModel(location: currentWeather.location.name, temperature: currentWeather.current.tempC, condition: currentWeather.current.condition.text)
    }
}
