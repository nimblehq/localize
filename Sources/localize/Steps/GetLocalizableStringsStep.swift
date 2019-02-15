//
//  GetLocalizableStringsStep.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation

final class GetLocalizableStringsStep: Step {
    
    enum Error: BaseError {
        case iterationFailure(Swift.Error)
    }
    
    static let name: String = "Generate strings from current localizable files (.strings)"
    
    static let description: String = "Gather all keys and values from all Localizable.strings and generate a dictionary"
    
    var verbose: Bool = true
    
    private let matcher = StringMatcher(format: .strings)
    private let iterator = FileIterator(acceptedFileExtensions: [.strings],
                                        excludedFolderNames: ["Pod"])
    
    // MARK: - step
    
    func run() -> Result<[URL: MatchDictionary], Error> {
        do {
            var dictionary: [URL: MatchDictionary] = [:]
            try iterator.enumerate { url, content in
                dictionary[url] = getMatchDictionary(from: content)
            }
            // todo: - log for verbose
            return .success(dictionary)
        } catch { return .failure(.iterationFailure(error)) }
    }
    
    // MARK: - private helper
    
    private func getMatchDictionary(from content: String) -> MatchDictionary? {
        guard let result = try? matcher.find(in: content) else { return nil }
        return MatchDictionary(result)
    }
    
}
