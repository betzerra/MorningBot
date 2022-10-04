//
//  ScriptStep.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 03/10/2022.
//

import Foundation

protocol ScriptStep {
    func message() async throws -> String
}
