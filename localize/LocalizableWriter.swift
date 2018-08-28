//
//  LocalizableWriter.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

typealias MatchDictionary = [MatchString: String?]

final class LocalizableWriter {
    
    enum Error: Swift.Error {
        case invalidURL
    }
    
    private let fileManager = FileManager.default
    
    func write(at url: URL, with dictionary: MatchDictionary) throws {
        guard url.pathExtension == "strings" else { throw Error.invalidURL }
        
        let content = dictionary
            .sorted { $0.key < $1.key }
            .map { matchString, value in
                """
                \(matchString.comment.isEmpty ? "" : "\\* \(matchString.comment) *\\\n")\
                "\(matchString.domain).\(matchString.module).\(matchString.name)" = "\(value ?? "")"
                """
            }
            .joined(separator: "\n\n")
        print(content)
    }
    
}
