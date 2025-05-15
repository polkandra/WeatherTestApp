//
//  WeatherHourForecastDTO.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 15.05.2025.
//

import Foundation

struct WeatherForecastDTO: Codable {
    let location: Location?
    let current: Current?
    let forecast: Forecast?
}

struct Forecast: Codable {
    let forecastday: [Forecastday]?
}

struct Forecastday: Codable {
    let date: String?
    let dateEpoch: Int?
    let day: Day?
    let astro: Astro?
    let hour: [Current]?

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, astro, hour
    }
}

struct Astro: Codable {
    let sunrise, sunset, moonrise, moonset: String?
}

struct Day: Codable {
    let maxtempC, mintempC, avgtempC: Double?
    let condition: Condition?

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case condition
    }
}
