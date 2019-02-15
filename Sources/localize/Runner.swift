//
//  Runner.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class Runner {
    
    enum Error: Swift.Error {
        
        case noOutput(stepName: String, type: Any.Type)
        
    }
    
    var verbose = true
    
    func run() throws {
        guard let iteratedLocalizedKeys = try run(step: GenerateStringsStep()).output else {
            throw Error.noOutput(stepName: GenerateStringsStep.name, type: GenerateStringsStep.Output.self)
        }
        
        guard let urlForMatchDictionary = try run(step: GetLocalizableStringsStep()).output else {
            throw Error.noOutput(stepName: GetLocalizableStringsStep.name,
                                 type: GetLocalizableStringsStep.Output.self)
        }

        guard
            let combinedMatchDictionary = try run(step: CombineStringsStep(
                localizableDictionary: urlForMatchDictionary,
                iteratedMatchDictionary: iteratedLocalizedKeys)
            ).output
        else {
            throw Error.noOutput(stepName: CombineStringsStep.name, type: CombineStringsStep.Output.self)
        }
        
        try run(step: WriteLocalizablesStep(writingDictionary: combinedMatchDictionary))
        
        log(step: "Success! 🎉")
    }
    
    // MARK: - private helper
    
    @discardableResult
    private func run<RunStep: Step>(step: RunStep) throws -> Result<RunStep.Output, RunStep.Error> {
        log(step: RunStep.name)
        logIfNeeded(RunStep.description)
        
        let result = step.run()
        if case .failure(let error) = result, error.isFatal {
            throw error
        }
        return result
    }
    
    private func log(step: String) {
        print("### " + step + " ###\n")
    }
    
    private func logIfNeeded(_ text: String) {
        guard verbose else { return }
        print("> " + text + "\n")
    }
    
}
