//
//  SenderConfig.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 05/10/2022.
//

import Foundation

enum SenderType: String, Codable {
    case telegram
}

struct SenderConfig: Decodable {
    let value: Value

    enum Value {
        case telegram(TelegramSender)
    }

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case token
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(SenderType.self, forKey: .type)

        switch type {
        case .telegram:
            let token = try container.decode(String.self, forKey: .token)
            let chatId = try container.decode(Int64.self, forKey: .chatId)
            value = .telegram(TelegramSender(token: token, chatId: chatId))
        }
    }
}
