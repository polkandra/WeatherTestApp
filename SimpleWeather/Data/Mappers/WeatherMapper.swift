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
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = .current
    
        let hour = calendar.component(.hour, from: Date.today)
        let todayStart = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date.today)!
    
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date.today)!
        let tomorrowEnd = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: tomorrow)!
        
        weatherForecast.forecast?.forecastday?.forEach { forecastday in
            let filtered = forecastday.hour?.filter { hour in
                guard let date = formatter.date(from: hour.time ?? "") else {
                    return false
                }
               
                return date >= todayStart && date <= tomorrowEnd
            }
            
            filtered?.forEach { current in
                hoursDataSource.append(
                    HourForecastWeatherModel(
                        hour: "\(Date.from(current.time ?? "")?.hour ?? 0)",
                        icon: current.condition?.icon ?? "",
                        temperature: current.tempC ?? 0
                    )
                )
            }
            
            if !hoursDataSource.isEmpty {
                hoursDataSource[0].hour = "Now"
            }
        }
        
        return hoursDataSource
    }
}
