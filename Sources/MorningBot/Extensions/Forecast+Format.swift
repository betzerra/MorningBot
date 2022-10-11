//
//  Forecast+Format.swift
//  
//
//  Created by Ezequiel Becerra on 11/10/2022.
//

import Foundation
import OpenWeather

extension Forecast {
    var formattedMinimum: String {
        formatted(prefix: "MIN: ", item: todaysMinimum)
    }

    var formattedMaximum: String {
        formatted(prefix: "MAX: ", item: todaysMaximum)
    }

    func formatted(prefix: String, item: WeatherEntry?) -> String {
        guard let item = item else {
            return prefix.appending("-")
        }

        return prefix.appending(item.temperature.celcius)
    }
}
