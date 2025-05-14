//
//  CurrentWeatherDTO.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import Foundation

struct CurrentWeatherDTO: Codable {
    let location: Location
    let current: Current
}

struct Current: Codable {
    let tempC: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
    }
}

struct Condition: Codable {
    let text, icon: String
    let code: Int
}

struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
    }
}
