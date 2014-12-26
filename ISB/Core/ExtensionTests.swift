//
//  ExtensionTests.swift
//  ISB
//
//  Created by Christopher Martin on 12/13/14.
//
//

import Foundation
import XCTest

class ExtensionTests: XCTestCase {
    func testEmptyQuerySting() {
        let params = "http://www.youtube.com".dictionaryFromQueryStringComponents()
        XCTAssertEqual(params.count, 0, "There should be no entires in the dictionary")
    }
}