//
//  Currency.swift
//  
//
//  Created by Ezequiel Becerra on 07/10/2022.
//

import Foundation

struct Currency: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case average = "value_avg"
        case buy = "value_buy"
        case sell = "value_sell"
    }

    let average: Float
    let sell: Float
    let buy: Float

    var spread: Float {
        sell - buy
    }

    var formattedAverage: String {
        String(format: "$%.2f", average)
    }

    var formattedBuy: String {
        String(format: "$%.2f", buy)
    }

    var formattedSell: String {
        String(format: "$%.2f", sell)
    }

    var formattedSpread: String {
        String(format: "$%.2f", spread)
    }
}
