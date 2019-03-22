//
//  PluralizeCommand.swift
//  AEXML
//
//  Created by Pirush Prechathavanich on 3/22/19.
//

struct PluralizeCommand: Command {
    
    static let key = "pluralize"
    
    let options: [NoOption] = []
    
    // MARK: - command
    
    func run() throws {
        guard let iteratedStringsdictKeys = try run(step: GenerateStringsStep(
            format: .pluralSwift
        )).output else {
            throw CommandError.noOutput(stepName: GenerateStringsStep.name,
                                        type: GenerateStringsStep.Output.self)
        }
        
        guard let urlForContents = try run(step: GetStringsdictStep()).output else {
            throw CommandError.noOutput(stepName: GetStringsdictStep.name,
                                        type: GetStringsdictStep.Output.self)
        }
        
        let urlForPluralStrings = try urlForContents
            .mapValues { try run(step: ParseToPluralStringStep(content: $0)).output ?? [] }
        
        var unpluralizedKeys: Set<String> = Set()
        iteratedStringsdictKeys.forEach { key, _ in
            urlForPluralStrings.forEach { url, pluralStrings in
                let hasKey = pluralStrings.contains { $0.key == key.description }
                if !hasKey { unpluralizedKeys.insert(key.description) }
            }
        }
        
        if unpluralizedKeys.isEmpty {
            log(step: "Pluralize validation successful! 🎉")
        } else {
            logIfNeeded("There're keys that hasn't been pluralized")
            unpluralizedKeys.forEach { logIfNeeded($0) }
            throw Error.unpluralizedKeysExist(unpluralizedKeys)
        }
    }
    
    enum Error: BaseError {
        case unpluralizedKeysExist(Set<String>)
    }
    
}
