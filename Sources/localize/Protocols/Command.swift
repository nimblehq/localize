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

extension Command {
    
    @discardableResult
    func run<RunStep: Step>(step: RunStep) throws -> Result<RunStep.Output, RunStep.Error> {
        log(step: RunStep.name)
        logIfNeeded(RunStep.description)
        
        let result = step.run()
        if case .failure(let error) = result, error.isFatal {
            throw error
        }
        return result
    }
    
    func log(step: String) {
        print("### 🌳 " + step + " ###\n")
    }
    
    func logIfNeeded(_ text: String) {
        // todo: - guard verbose else { return }
        print("> " + text + "\n")
    }
    
}
