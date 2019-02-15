//
//  MatchString.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

typealias MatchDictionary = [MatchString: String?]

struct MatchString: Hashable, Comparable, CustomStringConvertible {
    
    let domain: String
    let module: String
    let name: String
    
    let comment: String
    
    // MARK: - custom string convertible
    
    var description: String {
        return "\(domain).\(module).\(name)"
    }
    
    // MARK: - hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(domain)
        hasher.combine(module)
        hasher.combine(name)
    }
    
    // MARK: - equatable
    
    static func == (lhs: MatchString, rhs: MatchString) -> Bool {
        return lhs.domain == rhs.domain
            && lhs.module == rhs.module
            && lhs.name == rhs.name
    }
    
    // MARK: - comparable
    
    static func < (lhs: MatchString, rhs: MatchString) -> Bool {
        return lhs.description < rhs.description
    }
    
}
