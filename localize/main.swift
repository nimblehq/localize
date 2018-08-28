//
//  main.swift
//  localize
//
//  Created by Pirush Prechathavanich on 8/28/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation


var swiftResults = MatchDictionary()
do {
    let matcher = StringMatcher(format: .swift)
    let iterator = FileIterator(acceptedFileExtensions: ["swift"], excludedFolderNames: ["Pods"])
    try iterator.enumerate { _, content in
        guard let result = try? matcher.find(in: content) else { return }
        swiftResults.merge(result) { $1 }
    }
} catch { print(error) }

var stringsResult = MatchDictionary()
var localizableDictionary = [URL: MatchDictionary]()
do {
    let matcher = StringMatcher(format: .strings)
    let iterator = FileIterator(acceptedFileExtensions: ["strings"], excludedFolderNames: ["Pods"])
    try iterator.enumerate { url, content in
        guard let result = try? matcher.find(in: content) else { return }
        if let currentDictionary = localizableDictionary[url] {
            return localizableDictionary[url] = currentDictionary.merging(result) { $1 }
        }
        localizableDictionary[url] = MatchDictionary(result.map { (key: $0, value: $1) })
    }
} catch { print(error) }

print(swiftResults)
print("\n ============= \n")
print(stringsResult)

let test = """

/* Card Number Field of payment booking */
"booking.carddetails.cardnumber" = "카드번호";

"booking.card_details.expiration_date_month" = "유효기간 / 월";

/* Expiration year for Credit card */
"booking.card_details.expiration_year" = "연도";

/* CCV / Security code of credit card */
"aaaaaaaaaa.card_details.security_code" = "CVV/ 카드보안코드";

"booking.a.security_code" = "CVV/ 카드보안코드";

"""



do {
    let matcher = StringMatcher(format: .strings)
    let team = try matcher.find(in: test)
    let dict = team.map { $0.matchString.description }.joined(separator: "\n")
    let writer = LocalizableWriter()
    try writer.write(at: URL(fileURLWithPath: "team.strings"), with: MatchDictionary(team.map { (key: $0, value: $1) }))
} catch { print(error) }

