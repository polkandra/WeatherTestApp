//
//  WeatherMapper.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import Foundation

protocol WeatherMapper {
    func currentWeatherModel(weatherForecast: WeatherForecastDTO) -> CurrentWeatherModel
    func hourWeatherModel(weatherForecast: WeatherForecastDTO) -> [HourForecastWeatherModel]
}

final class WeatherMapperImpl: WeatherMapper {
    func currentWeatherModel(weatherForecast: WeatherForecastDTO) -> CurrentWeatherModel {
        var currentWeatherModel = CurrentWeatherModel(
            maxTemperature: 0,
            minTemperature: 0,
            averageTemperature: 0,
            location: "",
            temperature: 0,
            condition: ""
        )
        
        weatherForecast.forecast?.forecastday?.forEach { forecastday in
            currentWeatherModel = CurrentWeatherModel(
                maxTemperature: forecastday.day?.maxtempC ?? 0,
                minTemperature: forecastday.day?.mintempC ?? 0,
                averageTemperature: forecastday.day?.avgtempC ?? 0,
                location: weatherForecast.location?.name ?? "",
                temperature: weatherForecast.current?.tempC ?? 0,
                condition: weatherForecast.current?.condition?.text ?? ""
            )
        }
        
        return currentWeatherModel
    }
    
    func hourWeatherModel(weatherForecast: WeatherForecastDTO) -> [HourForecastWeatherModel] {
        var hoursDataSource: [HourForecastWeatherModel] = []
        
        weatherForecast.forecast?.forecastday?.forEach { forecastday in
            forecastday.hour?.forEach { hour in
                hoursDataSource.append(
                    HourForecastWeatherModel(
                        hour: Date.from(hour.time ?? "")?.hour ?? 0,
                        icon: hour.condition?.icon ?? "",
                        temperature: hour.tempC ?? 0
                    )
                )
            }
        }
        
        return hoursDataSource
    }
}
