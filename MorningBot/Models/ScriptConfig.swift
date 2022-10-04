//
//  ScriptConfig.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation
import Clarinete

enum ScriptError: Error {
    case wrongHost
}

enum ScriptType: String, Codable {
    case ClarineteNews = "clarinete_news"
}

struct ScriptConfig: Codable {
    let type: ScriptType

    func message() async throws -> String {
        guard let url = URL(string: "https://clarinete.seppo.com.ar") else {
            throw ScriptError.wrongHost
        }

        let configuration = Configuration(host: url)

        let client = try Clarinete(configuration: configuration)
        var message: String = ""

        try await client.getTrends().forEach { trend in
            guard let summary = trend.summary else {
                return
            }

            message += "- *\(trend.name):* \(summary.text)\n"
        }
        return message
    }
}
