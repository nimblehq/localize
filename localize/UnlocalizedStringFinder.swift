//
//  UnlocalizedStringFinder.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/29/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class UnlocalizedStringFinder {
    
    func find(in string: String) throws -> [String] {
        //"\"[^\"\\\]*(?:\\\.[^\"\\\]*)*\""
        let regex = try NSRegularExpression(pattern: "\"[^\"\\\\]*(?:\\\\.[^\"\\\\]*)*\"",
                                            options: .caseInsensitive)
        let result = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        return try result.map { try String(substring(from: string, in: $0.range)) }
    }
    
    private func substring(from string: String, in range: NSRange) throws -> String {
        guard let range = Range(range, in: string) else {
            throw StringMatcher.Error.cannotGetCapturedGroup
        }
        return String(string[range])
    }
    
}

extension Runner {
    
    func findUnlocalizedStrings() throws {
        let finder = UnlocalizedStringFinder()
        let iterator = FileIterator(acceptedFileExtensions: ["swift"],
                                    excludedFolderNames: ["Pods", "BraiveTests", "BraiveUITests"])
        try iterator.enumerate { url, content in
            guard
                let result = try? finder.find(in: content),
                !result.isEmpty
            else { return }
            print("> url: " + url.relativePath)
            print(">")
            result.forEach { print("> ", $0) }
        }
    }
}
