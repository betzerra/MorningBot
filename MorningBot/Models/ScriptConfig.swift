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
}

struct ScriptConfig: Decodable {
    let value: Value

    enum Value: Decodable {
        case clarineteNews(ClarineteStep)
    }

    enum CodingKeys: String, CodingKey {
        case limit
        case type
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(ScriptType.self, forKey: .type)

        switch type {
        case .clarineteNews:
            let limit = try container.decode(Int.self, forKey: .limit)
            value = .clarineteNews(ClarineteStep(limit: limit))
        }
    }
}
