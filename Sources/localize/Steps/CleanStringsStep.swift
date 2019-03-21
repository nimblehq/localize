//
//  CleanStringsStep.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

import Foundation

final class CleanStringsStep: Step {
    
    static let name: String = "Clean unused keys"
    
    static let description: String = "Clean up current unused keys comparing with the iterated ones"
    
    var verbose: Bool = true
    
    let localizableDictionary: [URL: MatchDictionary]
    
    let iteratedMatchDictionary: MatchDictionary
    
    init(localizableDictionary: [URL: MatchDictionary], iteratedMatchDictionary: MatchDictionary) {
        self.localizableDictionary = localizableDictionary
        self.iteratedMatchDictionary = iteratedMatchDictionary
    }
    
    // MARK: - step
    
    func run() -> Result<[URL: MatchDictionary], NoError> {
        var result: [URL: MatchDictionary] = [:]
        localizableDictionary.forEach { url, dictionary in
            result[url] = cleanedMatchDictionary(merging: dictionary)
        }
        return .success(result)
    }
    
    // MARK: - private helper
    
    private func cleanedMatchDictionary(merging currentDictionary: MatchDictionary) -> MatchDictionary {
        return currentDictionary.filter { key, _ in iteratedMatchDictionary.keys.contains(key) }
    }
    
}
