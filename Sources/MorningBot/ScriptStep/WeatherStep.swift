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
        formatter.dateFormat = "hha"
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
        let lines = forecast.cluster(by: 2)
            .filter { Calendar.current.isDateInToday($0.date) }
            .map { item in
            let components: [String] = [
                "*\(lineDateFormatter.string(from: item.date))*",
                item.type.emoji,
                item.temperature.celcius
            ]

            return components.joined(separator: " ")
        }

        return lines.joined(separator: "\n")
    }
}
