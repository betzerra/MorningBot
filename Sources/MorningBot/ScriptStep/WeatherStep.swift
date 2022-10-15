//
//  WeatherStep.swift
//  
//
//  Created by Ezequiel Becerra on 10/10/2022.
//

import Foundation
import OpenWeather

class WeatherStep: ScriptStep {
    let latitude: Double
    let longitude: Double
    
    let token: String
    let shouldNotify: Bool

    private let lineDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hha" // looks like: 09AM, 03PM...
        return formatter
    }()

    init(latitude: Double, longitude: Double, token: String, shouldNotify: Bool) {
        self.latitude = latitude
        self.longitude = longitude
        self.token = token
        self.shouldNotify = shouldNotify
    }

    func message() async throws -> String {
        let client = OpenWeather(token: token, baseURL: nil)
        let forecast = try await client.forecast(latitude: latitude, longitude: longitude)

        var summary = weatherSummary(from: forecast)
        summary += "\n\n"

        let lastLine = [
            forecast.formattedMinimum,
            forecast.formattedMaximum
        ].joined(separator: " - ")

        summary += lastLine
        return summary
    }

    private func weatherSummary(from forecast: Forecast) -> String {
        let lines = nearestForecast(from: forecast).map { item in
            let components: [String] = [
                "*\(lineDateFormatter.string(from: item.date))*",
                item.type.emoji,
                item.temperature.decimal.appending("ºC")
            ]

            return components.joined(separator: " ")
        }

        return lines.joined(separator: "\n")
    }

    /// Returns today's or tomorrow's forecast.
    /// - NOTE: Returns tomorrow's forecast when requested near midnight
    private func nearestForecast(from forecast: Forecast) -> [WeatherEntry] {
        let forecast = forecast.cluster(by: 2)
        let todayForecast = forecast.filter { Calendar.current.isDateInToday($0.date) }

        // If there's no weather information for today,
        // then return forecast for tomorrow
        guard todayForecast.count > 0 else {
            return forecast.filter { Calendar.current.isDateInTomorrow($0.date) }
        }

        return todayForecast
    }
}
