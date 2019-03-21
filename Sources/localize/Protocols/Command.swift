//
//  Command.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

protocol Command {
    
    associatedtype Option
    
    static var key: String { get }
    
    var options: [Option] { get }
    
    func run() throws
    
}
