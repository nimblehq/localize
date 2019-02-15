//
//  WriteLocalizablesStep.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation

final class WriteLocalizablesStep: Step {
    
    enum Error: BaseError {
        case invalidFileExtension
    }
    
    static let name: String = "Write values to Localizable.strings files"
    
    static let description: String = ""
    
    var verbose: Bool = true
    
    let writingDictionary: [URL: MatchDictionary]
    
    private let writer: LocalizableWriter
    
    init(writingDictionary: [URL: MatchDictionary]) {
        self.writingDictionary = writingDictionary
        self.writer = LocalizableWriter()
    }
    
    // MARK: - step
    
    func run() -> Result<NoOutput, Error> {
        do {
            try writingDictionary
                .filter { $0.key.lastPathComponent == "Localizable.strings" }
                .forEach(writer.write)
            return .success(.none)
        } catch { return .failure(.invalidFileExtension) }
    }
    
}
