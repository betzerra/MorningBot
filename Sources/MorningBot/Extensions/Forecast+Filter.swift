//
//  Forecast+Filter.swift
//  
//
//  Created by Ezequiel Becerra on 11/10/2022.
//

import Foundation
import OpenWeather

extension Forecast {
    var todaysMinimum: WeatherEntry? {
        list
            .filter { Calendar.current.isDateInToday($0.date) }
            .min { lhs, rhs in
                lhs.minimum < rhs.minimum
            }
    }

    var todaysMaximum: WeatherEntry? {
        list
            .filter { Calendar.current.isDateInToday($0.date) }
            .max { lhs, rhs in
                lhs.maximum < rhs.maximum
            }
    }
}
