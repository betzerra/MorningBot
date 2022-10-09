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
            let senders = config.senders.map { $0.sender }
            let steps = config.script.map { $0.scriptStep }

            Task.init {
                await MorningBot.send(steps: steps, using: senders)
                exit(EXIT_SUCCESS)
            }
        } catch {
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }

        dispatchMain()
    }

    private static func send(steps: [ScriptStep], using senders: [Sender]) async {
        for step in steps {
            do {
                let message = try await step.message()

                senders.forEach { sender in
                    sender.send(message: message, notify: step.shouldNotify)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
