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

    // MARK: - CodingKeys
    enum CommonCodingKeys: String, CodingKey {
        case notify
        case type
    }

    enum ClarineteCodingKeys: String, CodingKey {
        case host
        case muteTopics = "mute_topics"
        case limit
    }

    enum WeatherCodingKeys: String, CodingKey {
        case latitude
        case longitude
        case openweatherToken = "openweather_token"
    }

    // MARK: - Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CommonCodingKeys.self)

        let type = try container.decode(ScriptType.self, forKey: .type)
        let notify = try container.decode(Bool.self, forKey: .notify)

        switch type {
        case .clarineteNews:
            let clarineteContainer = try decoder.container(keyedBy: ClarineteCodingKeys.self)
            let host = try clarineteContainer.decode(URL.self, forKey: .host)
            let limit = try clarineteContainer.decode(Int.self, forKey: .limit)
            let muteTopics = try clarineteContainer.decodeIfPresent([String].self, forKey: .muteTopics) ?? []

            let step = ClarineteStep(
                host: host,
                muteTopics: muteTopics,
                limit: limit,
                shouldNotify: notify
            )
            
            self = .clarineteNews(step)

        case .dollar:
            self = .dollar(try DollarStep(shouldNotify: notify))

        case .weather:
            let weatherContainer = try decoder.container(keyedBy: WeatherCodingKeys.self)
            let latitude = try weatherContainer.decode(Double.self, forKey: .latitude)
            let longitude = try weatherContainer.decode(Double.self, forKey: .longitude)
            let token = try weatherContainer.decode(String.self, forKey: .openweatherToken)

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
