//
//  Float+Decimal.swift
//  
//
//  Created by Ezequiel Becerra on 08/10/2022.
//

import Foundation

extension Float {
    var decimal: String {
        String(format: "%.2f", self)
    }

    var celcius: String {
        String(format: "%.2fºC", self)
    }
}
