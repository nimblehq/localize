//
//  CombineStringsStep.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation

final class CombineStringsStep: Step {
    
    static let name: String = "Combine iterated strings with current ones"
    
    static let description: String = "Merge new iterated strings into the current ones from each url"
    
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
            result[url] = iteratedMatchDictionary(merging: dictionary)
        }
        return .success(result)
    }
    
    // MARK: - private helper
    
    private func iteratedMatchDictionary(merging currentDictionary: MatchDictionary) -> MatchDictionary {
        return iteratedMatchDictionary.merging(currentDictionary) { new, current in
            // todo: - log
            return current
        }
    }
    
}
