//
//  MorningBot.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation

@main
public struct MorningBot {
    public static func main() {
        do {
            let config = try Config.load()
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
        } catch {
            print(error.localizedDescription)
        }

        dispatchMain()
    }
}
