//
//  MorningBot.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Foundation
import ArgumentParser

@main
struct MorningBot: ParsableCommand  {
    @Option(
        name: .shortAndLong,
        help: "Configuration file to use with MorningBot"
    )
    var file: String = "config.json"

    mutating func run() throws {
        do {
            let config = try Config.load(file: file)
            let senders = config.senders.map { $0.sender }
            let steps = config.script.map { $0.scriptStep }

            Task.init {
                await MorningBot.send(steps: steps, using: senders)
                Darwin.exit(EXIT_SUCCESS)
            }
        } catch {
            print(error.localizedDescription)
            Darwin.exit(EXIT_FAILURE)
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
