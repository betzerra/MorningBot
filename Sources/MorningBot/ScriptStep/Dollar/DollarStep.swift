//
//  DollarStep.swift
//  
//
//  Created by Ezequiel Becerra on 07/10/2022.
//

import Foundation
import Pluma

enum DollarStepError: Error {
    case wrongHost
}

class DollarStep: ScriptStep {
    let client: Pluma
    let shouldNotify: Bool

    init(shouldNotify: Bool) throws {
        guard let url = URL(string: "https://api.bluelytics.com.ar/v2") else {
            throw DollarStepError.wrongHost
        }

        client = Pluma(baseURL: url, decoder: DollarStep.decoder())
        self.shouldNotify = shouldNotify
    }

    func message() async throws -> String {
        let exchange: DollarExchange = try await client.request(
            method: .GET,
            path: "latest",
            params: nil
        )

        return message(from: exchange)
    }

    func message(from exchange: DollarExchange) -> String {
        return """
        *Dolar oficial:* \(exchange.official.formattedSell) / \(exchange.official.formattedBuy) (spr: \(exchange.official.formattedSpread))
        *Dolar blue:* \(exchange.blue.formattedSell) / \(exchange.blue.formattedBuy) (spr: \(exchange.blue.formattedSpread))
        *Dif. blue / oficial:* \(exchange.formattedSpread)
        """
    }

    private static func defaultDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }

    static func decoder() -> JSONDecoder {
        let dateFormatter = DollarStep.defaultDateFormatter()

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            dateFormatter.date(from: dateString)
            if let date = dateFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        return decoder
    }
}
