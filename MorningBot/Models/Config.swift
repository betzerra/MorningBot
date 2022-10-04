//
//  Config.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

struct Config: Decodable {
    private let script: [ScriptConfig]

    var steps: [ScriptStep] {
        script.map { scriptConfig in
            switch scriptConfig.value {
            case .clarineteNews(let value):
                return value
            }
        }
    }
}
