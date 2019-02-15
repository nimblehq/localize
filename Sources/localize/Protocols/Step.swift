//
//  Step.swift
//  localize
//
//  Created by Pirush Prechathavanich on 2/15/19.
//

import Foundation

protocol Step {
    
    associatedtype Output
    associatedtype Error: BaseError
    
    static var name: String { get }
    static var description: String { get }
    
    var verbose: Bool { get set }
    
    func run() -> Result<Output, Error>
    
}

enum NoOutput {
    case none
}

enum NoError: BaseError {
    
    case none
    
    var isFatal: Bool { return false }
    
}
