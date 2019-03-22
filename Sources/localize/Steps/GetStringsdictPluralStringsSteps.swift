//
//  GetStringsdictPluralStringsSteps.swift
//  localize
//
//  Created by Pirush Prechathavanich on 3/22/19.
//

import AEXML

final class GetStringsPluralStringsStep: Step {
    
    enum Error: BaseError {
        
        case failed
        case missingKey(PluralKey)
        
        var localizedDescription: String {
            switch self {
            case .failed:
                return "failed"
            case .missingKey(let key):
                return "Failed due to missing key '\(key.rawValue)'"
            }
        }
        
    }
    
    static let name: String = "Generate plural strings from current stringsdict files (.stringsdict)"
    
    static let description: String = ""
    
    let content: String
    
    var verbose: Bool = true
    
    init(content: String) {
        self.content = content
    }
    
    // MARK: - step
    
    func run() -> Result<[PluralString], Error> {
        do {
            let document = try AEXMLDocument(xml: content)
            let dictionary = document["plist"]["dict"]
            
            print(dictionary.xml)
            
            print("\n\n###################### \n\n")
            try generate(from: dictionary.children)
            
            return .success([])
        } catch let error as Error {
            return .failure(error)
        } catch { return .failure(.failed) }
    }
    
    // MARK: - private helper
    
    private func generate(from elements: [AEXMLElement]) throws {
        guard elements.count % 2 == 0 else {
            return print("Nodes are supposed to be pairs, but instead got \(elements.count)")
        }

        let pluralStrings = try stride(from: 0, to: elements.count, by: 2)
            .map { (key: elements[$0].string, dictionary: elements[$0 + 1]) }
            .map(createPluralString)
        
        pluralStrings.forEach {
            print(">", $0.key, $0.dictionary.map { "\($0.rawValue): \($1)" })
        }
    }

    private func createPluralString(key: String, element: AEXMLElement) throws -> PluralString {
        guard let variable = getValue(fromKey: .localizedFormat, in: element) else {
            throw Error.missingKey(.localizedFormat)
        }
        
        let dictionary = element["dict"]
        
        guard let specString = getValue(fromKey: .formatSpecType, in: dictionary),
            let specFormat = PluralString.SpecFormat(rawValue: specString) else {
            throw Error.missingKey(.formatSpecType)
        }
        
        guard let valueString = getValue(fromKey: .formatValueType, in: dictionary),
            let valueFormat = PluralString.ValueFormat(rawValue: valueString) else {
            throw Error.missingKey(.formatValueType)
        }

        let pluralString = PluralString(key: key, specFormat: specFormat, valueFormat: valueFormat)
        
        PluralString.RuleKey.allCases
            .compactMap {
                guard let value = getValue(fromKey: $0.rawValue, in: dictionary) else { return nil }
                return (rule: $0, value: value)
            }
            .forEach { pluralString.dictionary[$0] = $1 }

        return pluralString
    }

    private func getValue(fromKey key: PluralKey, in element: AEXMLElement) -> String? {
        return getValue(fromKey: key.rawValue, in: element)
    }
    
    private func getValue(fromKey key: String, in element: AEXMLElement) -> String? {
        guard
            let keyElements = element["key"].all,
            let index = keyElements.firstIndex(where: { $0.value == key })
            else { return nil }
        
        return element["string"].all?[index].value
    }
    
}

enum PluralKey: String {
    
    case localizedFormat = "NSStringLocalizedFormatKey"
    case formatSpecType = "NSStringFormatSpecTypeKey"
    case formatValueType = "NSStringFormatValueTypeKey"
    
    var valueKey: String {
        switch self {
        case .localizedFormat, .formatSpecType, .formatValueType:
            return "string"
        }
    }
    
}
