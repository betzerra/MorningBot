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
    let limit: Int

    init(limit: Int) {
        self.limit = limit
    }

    func message() async throws -> String {
        guard let url = URL(string: "https://clarinete.seppo.com.ar") else {
            throw ClarineteStepError.wrongHost
        }

        let configuration = Configuration(host: url)

        let client = try Clarinete(configuration: configuration)
        var message: String = ""

        try await client.getTrends().prefix(limit).forEach { trend in
            guard let summary = trend.summary else {
                return
            }

            message += "- *\(trend.name):* \(summary.text) [link](\(summary.url)) \n\n"
        }
        return message
    }
}