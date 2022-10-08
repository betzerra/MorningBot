//
//  DollarExchangeService.swift
//  
//
//  Created by Ezequiel Becerra on 08/10/2022.
//

import Foundation
import Pluma

class DollarExchangeService {
    let url: URL
    let pluma: Pluma

    init(url: URL) {
        self.url = url
        self.pluma = Pluma(baseURL: url, decoder: DollarExchangeService.decoder())
    }

    func fetchDollarExchange() async throws -> DollarExchange {
        let exchange: DollarExchange = try await pluma.request(
            method: .GET,
            path: "latest",
            params: nil
        )

        return exchange
    }

    private static func defaultDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }

    static func decoder() -> JSONDecoder {
        let dateFormatter = DollarExchangeService.defaultDateFormatter()

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
