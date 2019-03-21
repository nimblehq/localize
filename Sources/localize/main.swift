//
//  main.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

let tool = CommandLineTool()

do {
    try tool.run()
} catch {
    print("\n ### ⚠️ Error: \(error) ### \n")
}
