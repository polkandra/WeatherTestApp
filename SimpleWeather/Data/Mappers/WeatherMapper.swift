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
    func dailyWeatherModel(weatherForecast: WeatherForecastDTO) -> [DailyForecastWeatherModel]
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
    
    func dailyWeatherModel(weatherForecast: WeatherForecastDTO) -> [DailyForecastWeatherModel] {
        var daysDataSource: [DailyForecastWeatherModel] = []
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = .current
    
        let weekStart = calendar.startOfDay(for: Date.today)
        let weekEndDay = calendar.date(byAdding: .day, value: 7, to: weekStart)!
        let weekEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: weekEndDay)!
        
        let filtered = weatherForecast.forecast?.forecastday?.filter { day in
            guard let date = formatter.date(from: day.date ?? "") else {
                return false
            }
           
            return date >= weekStart && date <= weekEnd
        }
        
        filtered?.forEach { day in
            daysDataSource.append(
                DailyForecastWeatherModel(
                    day: formatter.date(from: day.date ?? "")?.dayOfWeek() ?? "",
                    icon: day.day?.condition?.icon ?? "",
                    highTemp: "\(day.day?.maxtempC ?? 0)",
                    lowTemp: "\(day.day?.mintempC ?? 0)"
                )
            )
        }
        
        if !daysDataSource.isEmpty {
            daysDataSource[0].day = "Today"
        }
        
        return daysDataSource
    }
}
