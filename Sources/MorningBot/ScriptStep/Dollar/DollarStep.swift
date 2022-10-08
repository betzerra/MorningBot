//
//  DollarStep.swift
//  
//
//  Created by Ezequiel Becerra on 07/10/2022.
//

import Foundation
import Pluma

class DollarStep: ScriptStep {
    let coinbaseService: CoinbaseService
    let dollarExchangeService: DollarExchangeService
    let shouldNotify: Bool

    init(shouldNotify: Bool) throws {
        self.coinbaseService = try CoinbaseService()
        self.dollarExchangeService = try DollarExchangeService()
        self.shouldNotify = shouldNotify
    }

    func message() async throws -> String {
        let dollar: DollarExchange = try await dollarExchangeService.fetchDollarExchange()
        let btc: CoinbaseExchange = try await coinbaseService.fetch(coin: .btc)
        let eth: CoinbaseExchange = try await coinbaseService.fetch(coin: .eth)
        return message(dollar: dollar, btc: btc, eth: eth)
    }

    func message(
        dollar: DollarExchange,
        btc: CoinbaseExchange,
        eth: CoinbaseExchange
    ) -> String {
        return """
        *Dolar oficial:* \(dollar.official.sell.decimal) / \(dollar.official.buy.decimal) (spr: \(dollar.official.spread.decimal))
        *Dolar blue:* \(dollar.blue.sell.decimal) / \(dollar.blue.buy.decimal) (spr: \(dollar.blue.spread.decimal))
        *Dif. blue / oficial:* \(dollar.formattedSpread)

        *Crypto*
        *BTC-USD:* \(btc.last)
        *ETH-USD:* \(eth.last)
        """
    }
}
