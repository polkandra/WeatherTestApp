//
//  Constants.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

struct Constants {
    struct UserDefaultsKeys {
        static let savedLocation = "savedLocation"
    }
    
    static let currentWeatherUrl = "http://api.weatherapi.com/v1/current.json"
    static let forecastWeatherUrl = "http://api.weatherapi.com/v1/forecast.json"
    static let apiKey = "fa8b3df74d4042b9aa7135114252304"
    static let defaultLatitude: Double = 55.751244
    static let defaultLongitude: Double = 37.618423
}
