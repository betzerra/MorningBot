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
        let senders = config.generateSenders()

        config.generateSteps().forEach { step in
            Task.init {
                do {
                    let message = try await step.message()

                    senders.forEach { sender in
                        sender.send(message: message)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
