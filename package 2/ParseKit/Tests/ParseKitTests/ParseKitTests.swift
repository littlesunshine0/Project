//
//  ParseKitTests.swift
//  ParseKit
//

import XCTest
@testable import ParseKit

final class ParseKitTests: XCTestCase {
    
    func testFileTypeDetection() {
        XCTAssertEqual(ParseKit.detectType(path: "/test/file.swift"), .swift)
        XCTAssertEqual(ParseKit.detectType(path: "/test/file.json"), .json)
        XCTAssertEqual(ParseKit.detectType(path: "/test/file.md"), .markdown)
        XCTAssertEqual(ParseKit.detectType(path: "/test/Package.swift"), .swiftPackage)
        XCTAssertEqual(ParseKit.detectType(path: "/test/file.py"), .python)
        XCTAssertEqual(ParseKit.detectType(path: "/test/file.unknown"), .unknown)
    }
    
    func testParsedFile() {
        let file = ParsedFile(type: .swift, path: "/test.swift", metadata: ["lines": "100"], content: "let x = 1")
        
        XCTAssertEqual(file.type, .swift)
        XCTAssertEqual(file.path, "/test.swift")
        XCTAssertEqual(file.metadata["lines"], "100")
        XCTAssertEqual(file.content, "let x = 1")
    }
    
    func testFileStructure() {
        let entries = [
            FileEntry(name: "main.swift", path: "/src/main.swift", entryType: .file, size: 1024),
            FileEntry(name: "lib", path: "/src/lib", entryType: .directory, size: 0)
        ]
        let structure = FileStructure(entries: entries, totalSize: 1024, fileCount: 2)
        
        XCTAssertEqual(structure.entries.count, 2)
        XCTAssertEqual(structure.totalSize, 1024)
    }
    
    func testParsedSymbol() {
        let symbol = ParsedSymbol(name: "MyClass", type: "class", line: 10, signature: "class MyClass")
        
        XCTAssertEqual(symbol.name, "MyClass")
        XCTAssertEqual(symbol.type, "class")
        XCTAssertEqual(symbol.line, 10)
    }
    
    func testAllFileTypes() {
        let types = FileType.allCases
        XCTAssertTrue(types.count >= 20)
        XCTAssertTrue(types.contains(.swift))
        XCTAssertTrue(types.contains(.json))
        XCTAssertTrue(types.contains(.markdown))
    }
    
    func testContentParsing() async throws {
        let content = "let x = 1"
        let file = try await ParseKit.parse(content: content, as: .swift)
        
        XCTAssertEqual(file.type, .swift)
        XCTAssertEqual(file.content, content)
    }
}
