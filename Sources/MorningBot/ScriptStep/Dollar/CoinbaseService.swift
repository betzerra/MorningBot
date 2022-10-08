//
//  CoinbaseService.swift
//  
//
//  Created by Ezequiel Becerra on 08/10/2022.
//

import Foundation
import Pluma

enum CoinbaseServiceError: Error {
    case wrongURL
}

enum Coin {
    case btc
    case eth

    var path: String {
        switch self {
        case .btc:
            return "BTC-USD"
        case .eth:
            return "ETH-USD"
        }
    }
}

class CoinbaseService {
    let pluma: Pluma

    init() throws {
        guard let url = URL(string: "https://api.pro.coinbase.com") else {
            throw CoinbaseServiceError.wrongURL
        }

        self.pluma = Pluma(baseURL: url, decoder: JSONDecoder())
    }

    func fetch(coin: Coin) async throws -> CoinbaseExchange {
        let exchange: CoinbaseExchange = try await pluma.request(
            method: .GET,
            path: "products/\(coin.path)/stats",
            params: nil
        )

        return exchange
    }
}
