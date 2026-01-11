//
//  NavigationKitTests.swift
//  NavigationKit
//

import XCTest
@testable import NavigationKit

final class NavigationKitTests: XCTestCase {
    
    func testNavigationKitVersion() {
        XCTAssertEqual(NavigationKit.version, "1.0.0")
    }
    
    func testNavigationDestination() {
        XCTAssertEqual(NavigationDestination.allCases.count, 10)
        XCTAssertEqual(NavigationDestination.dashboard.icon, "square.grid.2x2")
    }
    
    func testNavigationSection() {
        XCTAssertEqual(NavigationSection.allCases.count, 4)
        XCTAssertEqual(NavigationSection.main.icon, "house")
    }
}
