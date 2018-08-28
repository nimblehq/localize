//
//  Dictionary+Creational.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

extension Dictionary {
    
    init(_ pairs: [Element]) {
        self.init()
        pairs.forEach { self[$0.key] = $0.value }
    }
    
}
