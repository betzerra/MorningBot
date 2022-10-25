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
    /// Ignore trending topics that contain the following words
    let muteTopics: [String]

    /// Maximum amount of trending topics the script should post
    let limit: Int

    /// Send a notification sound when posting a message if true
    let shouldNotify: Bool

    init(muteTopics: [String], limit: Int, shouldNotify: Bool) {
        self.muteTopics = muteTopics
        self.limit = limit
        self.shouldNotify = shouldNotify
    }

    func message() async throws -> String {
        var message: String = ""

        try await getTrends().forEach { trend in
            guard let summary = trend.summary else {
                return
            }

            message += "- *\(trend.name):* \(summary.text) [link](\(summary.url)) \n\n"
        }
        return message
    }

    func getTrends() async throws -> [Trend] {
        guard let url = URL(string: "https://clarinete.seppo.com.ar") else {
            throw ClarineteStepError.wrongHost
        }

        let configuration = Configuration(host: url)

        let client = try Clarinete(configuration: configuration)
        let topics = try await client.getTrends()
            .filter { $0.relatedTopics.isDisjoint(with: muteTopics) }
            .prefix(upTo: limit)

        return Array(topics)
    }
}
