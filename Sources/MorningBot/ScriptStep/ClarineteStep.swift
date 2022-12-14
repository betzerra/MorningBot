//
//  ClarineteStep.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 03/10/2022.
//

import Clarinete
import Foundation

enum ClarineteStepError: Error {
    case wrongHost
}

class ClarineteStep: ScriptStep {
    /// Host where the API is
    let host: URL

    /// Ignore trending topics that contain the following words
    let muteTopics: [String]

    /// Maximum amount of trending topics the script should post
    let limit: Int

    /// Send a notification sound when posting a message if true
    let shouldNotify: Bool

    init(host: URL, muteTopics: [String], limit: Int, shouldNotify: Bool) {
        self.host = host
        self.muteTopics = muteTopics
        self.limit = limit
        self.shouldNotify = shouldNotify
    }

    func message() async throws -> String {
        var message: String = ""

        try await getTrends().forEach { trend in
            guard let summary = trend.posts.first else {
                return
            }

            let unpaywallURL = "\(host)/unpaywall/\(summary.url)"
            message += "- *\(trend.name):* \(summary.title) [link](\(unpaywallURL)) \n\n"
        }

        message += "[Más noticias](\(host)) 🗞️"
        return message
    }

    func getTrends() async throws -> [Trend] {
        let configuration = Configuration(host: host)

        let client = try Clarinete(configuration: configuration)
        let topics = try await client.getTrends()
            .filter { $0.relatedTopics.isDisjoint(with: muteTopics) }
            .prefix(upTo: limit)

        return Array(topics)
    }
}
