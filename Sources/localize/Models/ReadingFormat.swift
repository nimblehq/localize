//
//  FileFormat.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

enum ReadingFormat {
    
    case swift
    case pluralSwift
    case strings
    
    var regexPattern: String {
        switch self {
        case .swift:        return "\"(\\w.+)\\.(\\w.+)\\.(\\w.+)\".localized"
        case .pluralSwift:  return "\"(\\w.+)\\.(\\w.+)\\.(\\w.+)\".pluralized\\("
        case .strings:      return "(\\/\\* (.*) \\*\\/(\r\n|\r|\n))?\"(\\w.+)\\.(\\w.+)\\.(\\w.+)\" = \"(.*)\";"
        }
    }
    
}
