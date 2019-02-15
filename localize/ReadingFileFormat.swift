//
//  FileFormat.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

enum ReadingFileFormat {
    
    case swift
    case strings
    
    var regexPattern: String {
        switch self {
        case .swift:        return "\"(\\w.+)\\.(\\w.+)\\.(\\w.+)\".localized"
        case .strings:      return "(\\/\\* (.*) \\*\\/(\r\n|\r|\n))?\"(\\w.+)\\.(\\w.+)\\.(\\w.+)\" = \"(.*)\";"
        }
    }
    
}
