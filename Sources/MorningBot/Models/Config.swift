//
//  Config.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

struct Config: Decodable {
    let script: [ScriptConfig]
    let senders: [SenderConfig]
}
