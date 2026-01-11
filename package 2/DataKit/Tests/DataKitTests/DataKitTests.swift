//
//  DataKitTests.swift
//  DataKit
//

import XCTest
@testable import DataKit

final class DataKitTests: XCTestCase {
    
    func testDataKitVersion() {
        XCTAssertEqual(DataKit.version, "1.0.0")
    }
    
    func testDataCategory() {
        XCTAssertEqual(DataCategory.allCases.count, 7)
        XCTAssertEqual(DataCategory.workflow.icon, "arrow.triangle.branch")
    }
    
    func testDataSection() {
        XCTAssertEqual(DataSection.allCases.count, 4)
        XCTAssertEqual(DataSection.all.icon, "cylinder")
    }
}
