//
//  Config+Load.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation
import Yams

extension Config {
    static func load() throws -> Config {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let url = URL(fileURLWithPath: "config.yml", relativeTo: currentDirectoryURL)

        let data = try Data(contentsOf: url)

        let decoder = YAMLDecoder()
        let config = try decoder.decode(Config.self, from: data)
        return config
    }
}
