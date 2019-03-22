//
//  RunCommand.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

struct RunCommand: Command {
    
    static let key = "run"
    
    let options: [Option]
    
    init(arguments: [String]) {
        options = arguments.compactMap(Option.init)
    }
    
    // MARK: - command
    
    func run() throws {
        guard let iteratedLocalizedKeys = try run(step: GenerateStringsStep(format: .swift)).output else {
            throw CommandError.noOutput(stepName: GenerateStringsStep.name,
                                        type: GenerateStringsStep.Output.self)
        }
        
        guard let urlForMatchDictionary = try run(step: GetLocalizableStringsStep()).output else {
            throw CommandError.noOutput(stepName: GetLocalizableStringsStep.name,
                                        type: GetLocalizableStringsStep.Output.self)
        }
        
        guard let combinedMatchDictionary = try run(step: CombineStringsStep(
            localizableDictionary: urlForMatchDictionary,
            iteratedMatchDictionary: iteratedLocalizedKeys
        )).output else {
            throw CommandError.noOutput(stepName: CombineStringsStep.name,
                                        type: CombineStringsStep.Output.self)
        }
        
        try run(step: WriteLocalizablesStep(writingDictionary: combinedMatchDictionary))
        
        log(step: "Running localize successful! 🎉")
    }
    
}

// MARK: - option

extension RunCommand {
    
    enum Option: String {
        
        case force = "force"
        
    }
    
}
