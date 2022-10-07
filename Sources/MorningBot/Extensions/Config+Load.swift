//
//  Config+Load.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

enum ConfigError: Error {
    case configNotFound
}

extension Config {
    static func load() throws -> Config {
        let data = try Data(contentsOf: try configURL())

        let decoder = JSONDecoder()
        let config = try decoder.decode(Config.self, from: data)
        return config
    }

    /// Returns a 'config.json' URL that should be in the same folder as the executable
    private static var sameFolderConfigURL: URL? {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let url = URL(fileURLWithPath: "config.json", relativeTo: currentDirectoryURL)
        return url
    }

    /// Returns an embedded 'config.json' URL
    private static var embeddedConfigURL: URL? {
        Bundle.module.url(forResource: "config", withExtension: "json")
    }

    /// Gets a valir 'config.json'
    /// - Note: sameFolderConfigURL has priority
    private static func configURL() throws -> URL {
        let urls = [sameFolderConfigURL, embeddedConfigURL]
        for url in urls {
            guard let url = url else {
                continue
            }

            if FileManager.default.fileExists(atPath: url.path) {
                return url
            }
        }

        throw ConfigError.configNotFound
    }
}
