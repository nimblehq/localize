//
//  Runner.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class Runner {
    
    var verbose = true
    
    func run() throws {
    }
    
    // MARK: - private helper
    
    @discardableResult
    private func run<RunStep: Step>(step: RunStep) throws -> Result<RunStep.Output, RunStep.Error> {
        log(step: RunStep.name)
        logIfNeeded(RunStep.description)
        
        let result = step.run()
        if case .failure(let error) = result, error.isFatal {
            throw error
        }
        return result
    }
    
    private func log(step: String) {
        print("### " + step + " ###\n")
    }
    
    private func logIfNeeded(_ text: String) {
        guard verbose else { return }
        print("> " + text + "\n")
    }
    
}
