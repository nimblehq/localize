//
//  GetStringdictStep.swift
//  AEXML
//
//  Created by Pirush Prechathavanich on 3/22/19.
//

import Foundation

final class GetStringsdictStep: Step {
    
    enum Error: BaseError {
        case iterationFailure(Swift.Error)
    }
    
    static let name: String = "Get content of all .stringsdict files"
    
    static let description: String = "Read all .stringsdict files recursive in current path"
    
    var verbose: Bool = true
    
    private let iterator = FileIterator(acceptedFileExtensions: [.stringsdict],
                                        excludedFolderNames: ["Pod"])
    
    // MARK: - step
    
    func run() -> Result<[URL: String], Error> {
        do {
            var dictionary: [URL: String] = [:]
            try iterator.enumerate { dictionary[$0] = $1 }
            return .success(dictionary)
        } catch { return .failure(.iterationFailure(error)) }
    }
    
}
