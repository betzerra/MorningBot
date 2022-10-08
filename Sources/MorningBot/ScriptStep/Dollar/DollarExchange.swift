//
//  DollarExchange.swift
//  
//
//  Created by Ezequiel Becerra on 07/10/2022.
//

import Foundation

struct DollarExchange: Codable {
    enum CodingKeys: String, CodingKey {
        case official = "oficial"
        case blue
        case updated = "last_update"
    }

    let updated: Date
    let official: Currency
    let blue: Currency

    var spread: Float {
        (blue.buy * 100 / official.buy) - 100
    }

    var formattedSpread: String {
        let text = String(format: "%.2f%%", spread)
        return spread > 0 ? "⬆️ \(text)" : "⬇️ \(text)"
    }
}
