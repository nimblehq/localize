//
//  BaseError.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation

protocol BaseError: Error {
    
    var isFatal: Bool { get }
    
}

extension BaseError {
    
    var isFatal: Bool { return true }
    
}
