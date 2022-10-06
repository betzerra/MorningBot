//
//  Config+Load.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

extension Config {
    static func load() throws -> Config {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let url = URL(fileURLWithPath: "config.json", relativeTo: currentDirectoryURL)

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let config = try decoder.decode(Config.self, from: data)
        return config
    }
}
