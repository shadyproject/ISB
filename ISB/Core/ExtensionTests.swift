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
    
    func testKeyNoValueFromString() {
        let noParam = "http://www.youtube.com/?thing".dictionaryFromQueryStringComponents()
        XCTAssertEqual(noParam.count, 0, "There should be no entires in the dictionary")
    }
    
    func testEmptyParamFromString() {
        let emptyParam = "http://www.youtube.com/?thing=".dictionaryFromQueryStringComponents()
        XCTAssertEqual(emptyParam.count, 1, "The dict should have 1 entry")
        let array = emptyParam["thing"]!
        XCTAssertEqual(array.first!, "", "The member value should be the empty string")
    }
}