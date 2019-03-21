//
//  CommandError.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

enum CommandError: Swift.Error {
    
    case noOutput(stepName: String, type: Any.Type)
    
}
