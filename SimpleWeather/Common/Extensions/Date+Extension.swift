//
//  Date+Extension.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 15.05.2025.
//

import Foundation

extension Date {
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    static func from(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale.current
        return formatter.date(from: string)
    }

    static var today: Date {
        return Date()
    }
}
