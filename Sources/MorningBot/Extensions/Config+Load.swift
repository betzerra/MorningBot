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
    /// Load a config so MorningBot can work with it
    /// - Note: Uses either a custom file, an embedded configuration from bundle or
    /// loads it from config.json that it's on the same root folder as the executable.
    static func load(file: String) throws -> Config {
        let url = try configURL(file: file)
        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let config = try decoder.decode(Config.self, from: data)
        return config
    }

    /// - Returns: a file URL that should be in the same folder as the executable
    private static func sameFolderConfigURL(file: String) -> URL? {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let url = URL(fileURLWithPath: file, relativeTo: currentDirectoryURL)
        return url
    }

    /// - Returns: An embedded 'config.json' URL
    private static var embeddedConfigURL: URL? {
        Bundle.module.url(forResource: "config", withExtension: "json")
    }

    /// Gets a valid 'config.json'
    /// - Note: sameFolderConfigURL has priority
    private static func configURL(file: String) throws -> URL {
        let urls = [
            sameFolderConfigURL(file: file),
            embeddedConfigURL
        ]

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
