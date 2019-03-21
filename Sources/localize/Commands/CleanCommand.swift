//
//  CleanCommand.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

struct CleanCommand: Command {
    
    static let key = "clean"
    
    let options: [NoOption] = []
    
    // MARK: - command
    
    func run() throws {
        guard let iteratedLocalizedKeys = try run(step: GenerateStringsStep()).output else {
            throw CommandError.noOutput(stepName: GenerateStringsStep.name,
                                        type: GenerateStringsStep.Output.self)
        }
        
        guard let urlForMatchDictionary = try run(step: GetLocalizableStringsStep()).output else {
            throw CommandError.noOutput(stepName: GetLocalizableStringsStep.name,
                                        type: GetLocalizableStringsStep.Output.self)
        }
        
        guard let cleanedMatchDictionary = try run(step: CleanStringsStep(
            localizableDictionary: urlForMatchDictionary,
            iteratedMatchDictionary: iteratedLocalizedKeys
        )).output else {
            throw CommandError.noOutput(stepName: CleanStringsStep.name,
                                        type: CleanStringsStep.Output.self)
        }
        
        try run(step: WriteLocalizablesStep(writingDictionary: cleanedMatchDictionary))
        
        log(step: "Cleaning up successful! 🎉")
    }
    
}
