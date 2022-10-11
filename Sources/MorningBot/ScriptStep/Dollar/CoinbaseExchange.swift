//
//  CoinbaseExchange.swift
//  
//
//  Created by Ezequiel Becerra on 08/10/2022.
//

import Foundation

/// Struct to represent exchange values from Coinbase
struct CoinbaseExchange: Codable {
    let high: String
    let low: String
    let last: String
}
