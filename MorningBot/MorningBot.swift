//
//  MorningBot.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

class MorningBot {
    let config: Config

    init(config: Config) {
        self.config = config
    }

    func run() {
        config.steps.forEach { step in
            Task.init {
                do {
                    try await print(step.message())
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
