//
//  Float+Decimal.swift
//  
//
//  Created by Ezequiel Becerra on 08/10/2022.
//

import Foundation

extension Float {
    /// - Returns: String with 2 decimals
    var decimal: String {
        String(format: "%.2f", self)
    }
}
