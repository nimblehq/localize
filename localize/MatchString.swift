//
//  MatchString.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

struct MatchString: Hashable, Comparable, CustomStringConvertible {
    
    let domain: String
    let module: String
    let name: String
    
    let comment: String
    
    var description: String { return "\(domain).\(module).\(name): \(comment)" }
    
    static func < (lhs: MatchString, rhs: MatchString) -> Bool {
        return lhs.domain < rhs.domain
            || lhs.module < rhs.module
            || lhs.name < rhs.name
    }
    
}
