//
//  main.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

do {
    let config = try Config.load()
    let processor = Processor(config: config)
    processor.run()
} catch {
    print(error.localizedDescription)
}

dispatchMain()
