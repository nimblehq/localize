//
//  Runner.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class Runner {
    
    var verbose = false
    
    func run() throws {
        log(step: "Generating strings...")
        let newDictionary = try getNewMatchDictionary()
        
        log(step: "Getting current localizable.strings files...")
        let localizableDictionary = try getLocalizableDictionary()
        
        log(step: "Merging new strings with current ones...")
        let result = updated(localizableDictionary, with: newDictionary)
        
        log(step: "Writing to localizable.strings files...")
        try writeLocalizables(with: result)
        
        log(step: "Success! 🎉")
    }
    
    // MARK: - private steps
    
    private func getNewMatchDictionary() throws -> MatchDictionary {
        var dictionary = MatchDictionary()
        let matcher = StringMatcher(format: .swift)
        let iterator = FileIterator(acceptedFileExtensions: ["swift"],
                                    excludedFolderNames: ["Pods"])
        try iterator.enumerate { _, content in
            guard let result = try? matcher.find(in: content) else { return }
            dictionary.merge(result) { $1 }
        }
        return dictionary
    }
    
    private func getLocalizableDictionary() throws -> [URL: MatchDictionary] {
        let matcher = StringMatcher(format: .strings)
        let iterator = FileIterator(acceptedFileExtensions: ["strings"],
                                    excludedFolderNames: ["Pods"])
        
        var dictionary = [URL: MatchDictionary]()
        try iterator.enumerate { url, content in
            guard let result = try? matcher.find(in: content) else { return }
            dictionary[url] = MatchDictionary(result)
        }
        return dictionary
    }
    
    private func updated(_ dictionary: [URL: MatchDictionary],
                         with newMatchDictionary: MatchDictionary) -> [URL: MatchDictionary] {
        var result = [URL: MatchDictionary]()
        dictionary.forEach { result[$0.key] = newMatchDictionary.merging($0.value) { $1 } }
        return result
    }
    
    private func writeLocalizables(with dictionary: [URL: MatchDictionary]) throws {
        try dictionary.forEach { url, matchDictionary in
            let writer = LocalizableWriter()
            try writer.write(at: url, with: matchDictionary)
        }
    }
    
    // MARK: - private helper
    
    private func log(step: String) {
        print("### " + step + " ###\n")
    }
    
}
