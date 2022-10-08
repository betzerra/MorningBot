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
    let dollarExchangeService: DollarExchangeService
    let shouldNotify: Bool

    init(shouldNotify: Bool) throws {
        guard let url = URL(string: "https://api.bluelytics.com.ar/v2") else {
            throw DollarStepError.wrongHost
        }

        self.dollarExchangeService = DollarExchangeService(url: url)
        self.shouldNotify = shouldNotify
    }

    func message() async throws -> String {
        let exchange: DollarExchange = try await dollarExchangeService.fetchDollarExchange()
        return message(from: exchange)
    }

    func message(from exchange: DollarExchange) -> String {
        return """
        *Dolar oficial:* \(exchange.official.formattedSell) / \(exchange.official.formattedBuy) (spr: \(exchange.official.formattedSpread))
        *Dolar blue:* \(exchange.blue.formattedSell) / \(exchange.blue.formattedBuy) (spr: \(exchange.blue.formattedSpread))
        *Dif. blue / oficial:* \(exchange.formattedSpread)
        """
    }
}
