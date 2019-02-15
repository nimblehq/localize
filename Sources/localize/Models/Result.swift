//
//  Result.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation

enum Result<Output, Error: Swift.Error> {
    
    case success(Output)
    case failure(Error)
    
    var output: Output? {
        if case .success(let output) = self { return output }
        return nil
    }
    
    var error: Error? {
        if case .failure(let error) = self { return error }
        return nil
    }
    
}
