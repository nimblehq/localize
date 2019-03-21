//
//  Collection+KeyPath.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/21/19.
//

import Foundation

extension Collection {
    
    func map<U>(_ keyPath: KeyPath<Element, U>) -> [U] {
        return map { $0[keyPath: keyPath] }
    }
    
}
