//
//  ProjectScaffoldTests.swift
//  ProjectScaffold
//

import XCTest
@testable import ProjectScaffold

final class ProjectScaffoldTests: XCTestCase {
    
    func testCreateFeature() throws {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        let featurePath = try ProjectScaffold.createFeature(
            name: "TestFeature",
            at: tempDir,
            description: "Test feature",
            tags: ["test"]
        )
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: featurePath.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: featurePath.appendingPathComponent("Models").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: featurePath.appendingPathComponent("Services").path))
    }
    
    func testAddCodeUnit() throws {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        let featurePath = try ProjectScaffold.createFeature(name: "TestFeature", at: tempDir)
        
        let unitPath = try ProjectScaffold.addCodeUnit(
            to: featurePath,
            name: "TestModel",
            kind: .struct,
            category: .models,
            tags: ["test"]
        )
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: unitPath.path))
        
        let content = try String(contentsOf: unitPath, encoding: .utf8)
        XCTAssertTrue(content.contains("struct TestModel"))
        XCTAssertTrue(content.contains("Kind: struct"))
    }
}
