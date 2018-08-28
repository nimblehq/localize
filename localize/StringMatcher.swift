//
//  StringMatcher.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct StringMatcher {
    
    typealias Result = (matchString: MatchString, value: String?)
    
    enum Error: Swift.Error {
        
        case cannotGetCapturedGroup
        case invalidFormat
        
    }
    
    let format: ReadingFileFormat
    
    init(format: ReadingFileFormat) {
        self.format = format
    }
    
    func find(in string: String) throws -> [Result] {
        let regex = try! NSRegularExpression(pattern: format.pattern, options: .caseInsensitive)
        let result = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        
        return try result
            .map { (string, $0) }
            .map(createMatchStringWithValue)
    }
    
    // MARK: - private
    
    
    private func createMatchStringWithValue(from string: String,
                                            with result: NSTextCheckingResult) throws -> Result {
        switch format {
        case .swift:
            return (
                MatchString(
                    domain: try substring(from: string, in: result.range(at: 1)),
                    module: try substring(from: string, in: result.range(at: 2)),
                    name: try substring(from: string, in: result.range(at: 3)),
                    comment: ""
                ),
                value: nil
            )
        case .strings:
            return (
                MatchString(
                    domain: try substring(from: string, in: result.range(at: 4)),
                    module: try substring(from: string, in: result.range(at: 5)),
                    name: try substring(from: string, in: result.range(at: 6)),
                    comment: (try? substring(from: string, in: result.range(at: 2))) ?? ""
                ),
                value: try substring(from: string, in: result.range(at: 7))
            )
        }
    }
    
    private func substring(from string: String, in range: NSRange) throws -> String {
        guard let range = Range(range, in: string) else {
            throw MatchError.cannotGetCapturedGroup
        }
        return String(string[range])
    }
    
}
