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
    static let apiKey = "094ba8e5d01b4d48a8595252252105"
    static let defaultLatitude: Double = 55.751244
    static let defaultLongitude: Double = 37.618423
}
