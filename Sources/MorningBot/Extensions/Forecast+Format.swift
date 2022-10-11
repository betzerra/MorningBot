//
//  Forecast+Format.swift
//  
//
//  Created by Ezequiel Becerra on 11/10/2022.
//

import Foundation
import OpenWeather

extension Forecast {
    /// - Returns: Something like: "MIN: 18ºC"
    var formattedMinimum: String {
        formatted(prefix: "MIN: ", item: todaysMinimum)
    }

    /// - Returns: Something like: "MAX: 32ºC"
    var formattedMaximum: String {
        formatted(prefix: "MAX: ", item: todaysMaximum)
    }

    private func formatted(prefix: String, item: WeatherEntry?) -> String {
        guard let item = item else {
            return prefix.appending("-")
        }

        return prefix.appending(item.temperature.decimal.appending("ºC"))
    }
}
