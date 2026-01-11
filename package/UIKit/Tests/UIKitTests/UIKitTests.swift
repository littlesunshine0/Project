//
//  UIKitTests.swift
//  UIKit
//

import XCTest
@testable import UIKit

final class UIKitTests: XCTestCase {
    
    func testUIKitInitialization() {
        UIKit.initialize()
        XCTAssertFalse(UISystemRegistry.shared.allSystems.isEmpty)
        XCTAssertFalse(LayoutTemplateRegistry.shared.allTemplates.isEmpty)
        XCTAssertFalse(KitContextRegistry.shared.allContexts.isEmpty)
    }
    
    func testSystemRegistry() {
        UISystemRegistry.shared.registerAll()
        XCTAssertNotNil(UISystemRegistry.shared.system(withId: "doubleSidebar"))
        XCTAssertNotNil(UISystemRegistry.shared.system(withId: "floatingPanel"))
        XCTAssertNotNil(UISystemRegistry.shared.system(withId: "bottomBar"))
    }
    
    func testLayoutTemplates() {
        LayoutTemplateRegistry.shared.registerAll()
        XCTAssertNotNil(LayoutTemplateRegistry.shared.template(withId: "ide.classic"))
        XCTAssertFalse(LayoutTemplateRegistry.shared.templates(for: .ide).isEmpty)
    }
    
    func testKitContexts() {
        KitContextRegistry.shared.registerAll()
        XCTAssertNotNil(KitContextRegistry.shared.context(for: "ChatKit"))
        XCTAssertNotNil(KitContextRegistry.shared.context(for: "FileKit"))
        XCTAssertEqual(KitContextRegistry.shared.allContexts.count, 37)
    }
}
