//
//  Runner.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class Runner {
    
    func run() throws {
        let newDictionary = try getNewMatchDictionary()
        let localizebleDictionary = try getLocalizableDictionary()
    }
    
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
    
}
