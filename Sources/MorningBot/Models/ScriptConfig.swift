//
//  ScriptConfig.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation
import Clarinete
import OpenWeather

enum ScriptType: String, Codable {
    case clarineteNews = "clarinete_news"
    case dollar
    case weather
}

/// Represents a message that the bot will post to some medium (such as Telegram for example)
/// - Note: This configuration is parsed from 'config.json' file.
enum ScriptConfig: Decodable {
    case clarineteNews(ClarineteStep)
    case dollar(DollarStep)
    case weather(WeatherStep)

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case limit
        case notify
        case openweatherToken = "openweather_token"
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(ScriptType.self, forKey: .type)
        let notify = try container.decode(Bool.self, forKey: .notify)

        switch type {
        case .clarineteNews:
            let limit = try container.decode(Int.self, forKey: .limit)
            self = .clarineteNews(ClarineteStep(limit: limit, shouldNotify: notify))

        case .dollar:
            self = .dollar(try DollarStep(shouldNotify: notify))

        case .weather:
            let latitude = try container.decode(Double.self, forKey: .latitude)
            let longitude = try container.decode(Double.self, forKey: .longitude)
            let token = try container.decode(String.self, forKey: .openweatherToken)

            let step = WeatherStep(
                latitude: latitude,
                longitude: longitude,
                token: token,
                shouldNotify: notify
            )

            self = .weather(step)
        }
    }

    var scriptStep: ScriptStep {
        switch self {
        case .clarineteNews(let value):
            return value
        case .dollar(let value):
            return value
        case .weather(let value):
            return value
        }
    }
}
