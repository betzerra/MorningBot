//
//  Forecast+Filter.swift
//  
//
//  Created by Ezequiel Becerra on 11/10/2022.
//

import Foundation
import OpenWeather

extension Forecast {
    /// - Returns: The moment that temperature is going to be
    /// at its minimum today
    var todaysMinimum: WeatherEntry? {
        list
            .filter { Calendar.current.isDateInToday($0.date) }
            .min { lhs, rhs in
                lhs.minimum < rhs.minimum
            }
    }

    /// - Returns: The moment that temperature is going to be
    /// at its maximum today
    var todaysMaximum: WeatherEntry? {
        list
            .filter { Calendar.current.isDateInToday($0.date) }
            .max { lhs, rhs in
                lhs.maximum < rhs.maximum
            }
    }
}
