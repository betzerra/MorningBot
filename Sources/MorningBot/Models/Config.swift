//
//  Config.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

struct Config: Decodable {
    private let script: [ScriptConfig]
    private let senders: [SenderConfig]

    func generateSteps() -> [ScriptStep] {
        script.map { scriptConfig in
            switch scriptConfig.value {
            case .clarineteNews(let value):
                return value

            case .dollar(let value):
                return value
            }
        }
    }

    func generateSenders() -> [Sender] {
        senders.map { sender in
            switch sender.value {
            case .telegram(let value):
                return value
            }
        }
    }
}
