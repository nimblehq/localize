//
//  FileIterator.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class FileIterator {
    
    enum Error: Swift.Error {
        
        case invalidURLPath
        
    }
    
    private let fileManager = FileManager.default
    
    private let acceptedFileExtensions: Set<String>
    private let excludedFolderNames: Set<String>
    private let excludedFileNames: Set<String>
    
    init(acceptedFileExtensions: [String] = [],
         excludedFolderNames: [String] = [],
         excludedFileNames: [String] = []) {
        self.acceptedFileExtensions = Set(acceptedFileExtensions)
        self.excludedFolderNames = Set(excludedFolderNames)
        self.excludedFileNames = Set(excludedFileNames + ["genstrings.swift"])
    }
    
    func enumerate(action: (URL, String) -> Void) throws {
        let directoryURL = URL(fileURLWithPath: "")
        guard
            let enumerator = fileManager.enumerator(at: directoryURL,
                                                    includingPropertiesForKeys: [.isDirectoryKey],
                                                    options: [.skipsHiddenFiles],
                                                    errorHandler: nil)
            else { return }
        
        for case let fileURL as URL in enumerator {
            if let isDirectory = try fileURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
                isDirectory,
                excludedFolderNames.contains(fileURL.lastPathComponent) {
                enumerator.skipDescendants()
                print("skip", fileURL)
                continue
            }
            
            if let content = validatedContent(from: fileURL) {
                action(fileURL, content)
            }
        }
    }
    
    private func validatedContent(from url: URL) -> String? {
        if acceptedFileExtensions.contains(url.pathExtension)
            && !excludedFileNames.contains(url.lastPathComponent) {
            return try? String(contentsOf: url, encoding: .utf8)
        }
        return nil
    }
    
}

