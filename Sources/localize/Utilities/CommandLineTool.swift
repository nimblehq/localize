//
//  CommandLineTool.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

import Foundation

final class CommandLineTool {
    
    enum Error: Swift.Error {
        
        case missingCommandArgument
        case invalidCommandArgument
    }
    
    let arguments: [String]
    
    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    func run() throws {
        var arguments = self.arguments
        arguments.removeFirst() // remove tool name (localize)
        
        guard arguments.count > 0 else { throw Error.missingCommandArgument }
        
        switch arguments.removeFirst() {
        case RunCommand.key:            try RunCommand(arguments: arguments).run()
        case CleanCommand.key:          try CleanCommand().run()
        default:                        throw Error.invalidCommandArgument
        }
    }
    
}
