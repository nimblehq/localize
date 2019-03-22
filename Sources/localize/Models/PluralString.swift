//
//  PluralString.swift
//  SWXMLHash
//
//  Created by Pirush Prechathavanich on 3/22/19.
//

final class PluralString {
    
    enum SpecFormat: String {
        
        case pluralRule = "NSStringPluralRuleType"
        
        static var key: String { return "NSStringFormatSpecTypeKey" }
    }
    
    /// For more information, head out to
    /// https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFStrings/formatSpecifiers.html#//apple_ref/doc/uid/TP40004265
    enum ValueFormat: String {
        
        case integer = "d"
        case unsignedInteger = "u"
        case float = "f"
        case object = "@"
        
    }
    
    enum RuleKey: String, CaseIterable {
        
        case zero
        case one
        case two
        case few
        case many
        case other
        
    }
    
    let key: String
    
    let specFormat: SpecFormat
    let valueFormat: ValueFormat
    
    var dictionary: [RuleKey: String] = [:]
    
    init(key: String, specFormat: SpecFormat, valueFormat: ValueFormat) {
        self.key = key
        self.specFormat = specFormat
        self.valueFormat = valueFormat
    }
    
}
