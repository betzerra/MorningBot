//
//  Processor.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

class Processor {
    let config: Config

    init(config: Config) {
        self.config = config
    }

    func run() {
        config.script.forEach { script in
            Task.init {
                do {
                    try await print(script.message())
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
