//
//  StringGenerator.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation


final class GenerateStringsStep: Step {
    
    enum Error: BaseError {
        case iterationFailure(Swift.Error)
    }
    
    static let name: String = "Generate strings from .swift files"
    
    static let description: String = "Gather all localized keys in the project and generate a dictionary"
    
    var verbose: Bool = true
    
    private let matcher = StringMatcher(format: .swift)
    private let iterator = FileIterator(acceptedFileExtensions: [.swift],
                                        excludedFolderNames: ["Pod"])
    
    // MARK: - step
    
    func run() -> Result<MatchDictionary, Error> {
        do {
            var dictionary = MatchDictionary()
            try iterator.enumerate { url, content in
                addLocalizedKeys(of: content, into: &dictionary)
            }
            // todo: - log for verbose
            //logIfNeeded("Found in " + url.lastPathComponent)
            //result.forEach { logIfNeeded($0.matchString.description) }
            //logIfNeeded("")
            return .success(dictionary)
        } catch { return .failure(.iterationFailure(error)) }
    }
    
    // MARK: - private helper
    
    private func addLocalizedKeys(of content: String, into dictionary: inout MatchDictionary) {
        if let result = try? matcher.find(in: content), !result.isEmpty {
            dictionary.merge(result) { $1 }
        }
    }

}
