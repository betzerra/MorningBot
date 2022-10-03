//
//  Processor.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 02/10/2022.
//

import Clarinete
import Foundation

class Processor {
    let config: Config

    init(config: Config) {
        self.config = config
    }

    func run() {
        config.script.forEach { script in
            switch script.type {
            case .ClarineteNews:
                fetchNews()
            }
        }
    }

    private func fetchNews() {
        let configuration = Configuration(host: "https://clarinete.seppo.com.ar")

        do {
            let clarinete = try Clarinete(configuration: configuration)
            let something = clarinete.getTrends { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let trends):
                    print(trends)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
