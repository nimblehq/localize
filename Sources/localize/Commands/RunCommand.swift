//
//  RunCommand.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

struct RunCommand: Command {
    
    enum Option: String {
        case force = "force"
    }
    
    static let key = "run"
    
    let options: [Option]
    
    init(arguments: [String]) {
        options = arguments.compactMap(Option.init)
    }
    
    func run() throws {
        try Runner().run()
    }
    
}
