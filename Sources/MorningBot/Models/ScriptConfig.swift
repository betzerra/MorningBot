//
//  ScriptConfig.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation
import Clarinete

enum ScriptType: String, Codable {
    case clarineteNews = "clarinete_news"
    case dollar
}

struct ScriptConfig: Decodable {
    let value: Value

    enum Value {
        case clarineteNews(ClarineteStep)
        case dollar(DollarStep)
    }

    enum CodingKeys: String, CodingKey {
        case limit
        case notify
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(ScriptType.self, forKey: .type)
        let notify = try container.decode(Bool.self, forKey: .notify)

        switch type {
        case .clarineteNews:
            let limit = try container.decode(Int.self, forKey: .limit)
            value = .clarineteNews(ClarineteStep(limit: limit, shouldNotify: notify))

        case .dollar:
            value = .dollar(try DollarStep(shouldNotify: notify))
        }
    }
}
