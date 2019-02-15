//
//  main.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class CommandLineTool {
    
    let arguments: [String]
    
    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    func run() throws {
        Runner().run()
    }
    
}

let tool = CommandLineTool()

do {
    try tool.run()
} catch {
    print("\n ### ⚠️ Error: \(error) ### \n")
}
