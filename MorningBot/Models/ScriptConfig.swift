//
//  ScriptConfig.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

enum ScriptType: String, Codable {
    case ClarineteNews = "clarinete_news"
}

struct ScriptConfig: Codable {
    let type: ScriptType
}
