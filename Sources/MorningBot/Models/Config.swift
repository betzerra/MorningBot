//
//  Config.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

/// Configuration struct that describes WHAT will be posted (script) and
/// WHERE will be posted (senders).
struct Config: Decodable {
    let script: [ScriptConfig]
    let senders: [SenderConfig]
}
