//
//  StepFactory.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 03/10/2022.
//

import Foundation

class StepFactory {
    static func steps(from config: [ScriptConfig]) -> [ScriptStep] {
        config.map { scriptConfig in
            switch scriptConfig.type {
            case .ClarineteNews:
                return ClarineteStep()
            }
        }
    }
}
