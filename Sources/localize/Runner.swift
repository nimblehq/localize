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
            let combinedMatchDictioanry = try run(step: CombineStringsStep(
                localizableDictionary: urlForMatchDictionary,
                iteratedMatchDictionary: iteratedLocalizedKeys)
            ).output
        else {
            throw Error.noOutput(stepName: CombineStringsStep.name, type: CombineStringsStep.Output.self)
        }
        
        log(step: "Writing to localizable.strings files...")
        try writeLocalizables(with: result)
        
        log(step: "Success! 🎉")
    }
    
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
    
    // MARK: - private steps
    
    private func updated(_ dictionary: [URL: MatchDictionary],
                         with newMatchDictionary: MatchDictionary) -> [URL: MatchDictionary] {
        var result = [URL: MatchDictionary]()
        dictionary.forEach {
            logIfNeeded("")
            logIfNeeded($0.key.relativePath)
            logIfNeeded("")
            result[$0.key] = newMatchDictionary.merging($0.value) {
                if $0 != $1 { logIfNeeded("selecting \($1 ?? "-") over \($0 ?? "-")") }
                return $1
            }
        }

        return result
    }
    
    private func writeLocalizables(with dictionary: [URL: MatchDictionary]) throws {
        try dictionary
            .filter { $0.key.lastPathComponent == "Localizable.strings" }
            .forEach { url, matchDictionary in
            logIfNeeded("writing localizable.strings at \(url.relativePath)\n")
            
            let writer = LocalizableWriter()
            try writer.write(at: url, with: matchDictionary)
        }
    }
    
    // MARK: - private helper
    
    private func log(step: String) {
        print("### " + step + " ###\n")
    }
    
    private func logIfNeeded(_ text: String) {
        guard verbose else { return }
        print("> " + text)
    }
    
}
