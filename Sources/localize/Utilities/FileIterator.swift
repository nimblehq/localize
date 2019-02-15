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
        case invalidURLPath, unsupportedOS
    }
    
    private let fileManager = FileManager.default
    
    let acceptedFileExtensions: Set<String>
    let excludedFolderNames: Set<String>
    let excludedFileNames: Set<String>
    
    init(acceptedFileExtensions: [String] = [],
         excludedFolderNames: [String] = [],
         excludedFileNames: [String] = []) {
        self.acceptedFileExtensions = Set(acceptedFileExtensions)
        self.excludedFolderNames = Set(excludedFolderNames)
        self.excludedFileNames = Set(excludedFileNames + ["genstrings.swift"])
    }
    
    func enumerate(action: (URL, String) -> Void) throws {
        guard #available(OSX 10.11, *) else { throw Error.unsupportedOS }
        
        let currentPath = CommandLine.arguments[0]
        let baseURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        let directoryURL = URL(fileURLWithPath: currentPath, relativeTo: baseURL)
            .deletingLastPathComponent()
        guard
            let enumerator = fileManager.enumerator(at: directoryURL,
                                                    includingPropertiesForKeys: [.isDirectoryKey],
                                                    options: [.skipsHiddenFiles],
                                                    errorHandler: nil)
        else { return }
        
        for case let fileURL as URL in enumerator {
            if try isURLDirectory(fileURL), excludedFolderNames.contains(fileURL.lastPathComponent) {
                enumerator.skipDescendants()
                continue
            }
            if let content = validatedContent(from: fileURL) {
                action(fileURL, content)
            }
        }
    }
    
    // MARK: - private
    
    private func isURLDirectory(_ url: URL) throws -> Bool {
        guard
            let isDirectory = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory
        else { return false }
        return isDirectory
    }
    
    private func validatedContent(from url: URL) -> String? {
        if acceptedFileExtensions.contains(url.pathExtension)
            && !excludedFileNames.contains(url.lastPathComponent) {
            do { return try String(contentsOf: url, encoding: .utf8) }
            catch { return try? String(contentsOf: url, encoding: .utf16) }
        }
        return nil
    }
    
}

