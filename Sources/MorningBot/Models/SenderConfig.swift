//
//  SenderConfig.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 05/10/2022.
//

import Foundation
import TelegramBotSDK

enum SenderType: String, Codable {
    case telegram
}

enum SenderConfigError: Error {
    case missingKeys
}

/// Represents a medium where the bot will post every message (such as Telegram for example)
/// - Note: This configuration is parsed from 'config.json' file.
enum SenderConfig: Decodable {
    case telegram(TelegramSender)

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case channel
        case token
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(SenderType.self, forKey: .type)

        switch type {
        case .telegram:
            let token = try container.decode(String.self, forKey: .token)

            guard let chatId = SenderConfig.chatId(from: container) else {
                throw SenderConfigError.missingKeys
            }

            self = .telegram(TelegramSender(token: token, chatId: chatId))
        }
    }

    var sender: Sender {
        switch self {
        case .telegram(let value):
            return value
        }
    }

    private static func chatId(from container: KeyedDecodingContainer<SenderConfig.CodingKeys>) -> TelegramBotSDK.ChatId? {
        if let chatId = try? container.decodeIfPresent(Int64.self, forKey: .chatId) {
            return .chat(chatId)

        } else if let channel = try? container.decodeIfPresent(String.self, forKey: .channel) {
            return .channel(channel)
        }

        return nil
    }
}
