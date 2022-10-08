import XCTest
import Pluma
@testable import MorningBot

final class DollarStepTests: XCTestCase {
    func testCurrencyParse() throws {
        let currencyJSON = """
        {
            "value_avg": 152.00,
            "value_sell": 156.00,
            "value_buy": 148.00
        }
        """

        let data = currencyJSON.data(using: .utf8)
        let currency = try! JSONDecoder().decode(Currency.self, from: data!)

        XCTAssertEqual(currency.average.decimal, "152.00")
        XCTAssertEqual(currency.sell.decimal, "156.00")
        XCTAssertEqual(currency.buy.decimal, "148.00")
        XCTAssertEqual(currency.spread.decimal, "8.00")
    }

    func testExchangeParse() throws {
        let exchange = try dollarExchange()
        let expectedCurrency = Currency(average: 152.00, sell: 156.00, buy: 148.00)
        XCTAssertEqual(exchange.official, expectedCurrency)
        XCTAssertEqual(exchange.formattedSpread, "⬆️ 84.46%")
        XCTAssertEqual(exchange.updated.timeIntervalSince1970, 1665183333.793)
    }

    func testMessage() throws {
        let step = try DollarStep(shouldNotify: false)
        let message = step.message(
            dollar: try dollarExchange(),
            btc: try coinbaseExchange(),
            eth: try coinbaseExchange()
        )

        let expectedMessage = """
        *Dolar oficial:* 156.00 / 148.00 (spr: 8.00)
        *Dolar blue:* 277.00 / 273.00 (spr: 4.00)
        *Dif. blue / oficial:* ⬆️ 84.46%

        *Crypto*
        *BTC-USD:* 19440.69
        *ETH-USD:* 19440.69
        """
        XCTAssertEqual(message, expectedMessage)
    }

    private func dollarExchange() throws -> DollarExchange {
        let exchangeJSON = """
        {
            "oficial": {
                "value_avg": 152.00,
                "value_sell": 156.00,
                "value_buy": 148.00
            },
            "blue": {
                "value_avg": 275.00,
                "value_sell": 277.00,
                "value_buy": 273.00
            },
            "oficial_euro": {
                "value_avg": 163.50,
                "value_sell": 168.00,
                "value_buy": 159.00
            },
            "blue_euro": {
                "value_avg": 296.00,
                "value_sell": 298.00,
                "value_buy": 294.00
            },
            "last_update": "2022-10-07T19:55:33.79345-03:00"
        }
        """

        let data = exchangeJSON.data(using: .utf8)
        return try DollarExchangeService.decoder().decode(DollarExchange.self, from: data!)
    }

    private func coinbaseExchange() throws -> CoinbaseExchange {
        let btcJSON = """
        {
            "open": "19945.06",
            "high": "20065.26",
            "low": "19325",
            "last": "19440.69",
            "volume": "33278.52816374",
            "volume_30day": "837561.11420341"
        }
        """

        let data = btcJSON.data(using: .utf8)
        return try JSONDecoder().decode(CoinbaseExchange.self, from: data!)
    }
}
