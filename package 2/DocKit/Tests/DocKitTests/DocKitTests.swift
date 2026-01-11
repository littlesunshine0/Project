//
//  DocKitTests.swift
//  DocKit
//

import XCTest
@testable import DocKit

final class DocKitTests: XCTestCase {
    
    func testREADMEGeneration() {
        let project = ProjectInfo(name: "TestKit", description: "A test package", features: ["Feature 1", "Feature 2"])
        let readme = DocKit.generateREADME(for: project)
        
        XCTAssertTrue(readme.contains("# TestKit"))
        XCTAssertTrue(readme.contains("A test package"))
        XCTAssertTrue(readme.contains("Feature 1"))
    }
    
    func testAPIDocGeneration() {
        let symbols = [
            CodeSymbol(name: "MyClass", type: .class, signature: "class MyClass", documentation: "A class"),
            CodeSymbol(name: "doSomething", type: .function, signature: "func doSomething()", documentation: "Does something")
        ]
        let docs = DocKit.generateAPIDocs(from: symbols)
        
        XCTAssertTrue(docs.contains("# API Reference"))
        XCTAssertTrue(docs.contains("MyClass"))
        XCTAssertTrue(docs.contains("doSomething"))
    }
    
    func testChangelogGeneration() {
        let commits = [
            CommitInfo(hash: "abc123", message: "feat: Add new feature", author: "Dev", date: Date(), type: .feature),
            CommitInfo(hash: "def456", message: "fix: Fix bug", author: "Dev", date: Date(), type: .fix)
        ]
        let changelog = DocKit.generateChangelog(from: commits)
        
        XCTAssertTrue(changelog.contains("# Changelog"))
        XCTAssertTrue(changelog.contains("Features"))
        XCTAssertTrue(changelog.contains("Bug Fixes"))
    }
    
    func testMarkdownParsing() async throws {
        let markdown = """
        # Title
        
        Some content
        
        ## Section
        
        More content
        
        ```swift
        let x = 1
        ```
        """
        
        let doc = try await DocKit.parse(markdown, format: .markdown)
        
        XCTAssertFalse(doc.sections.isEmpty)
        XCTAssertEqual(doc.sections.first?.title, "Title")
        XCTAssertFalse(doc.codeExamples.isEmpty)
    }
    
    func testHTMLParsing() async throws {
        let html = "<h1>Title</h1><p>Content</p><h2>Section</h2><p>More</p>"
        let doc = try await DocKit.parse(html, format: .html)
        
        XCTAssertFalse(doc.sections.isEmpty)
    }
    
    func testCommitTypeDetection() {
        XCTAssertEqual(CommitInfo.CommitType.from("feat: new feature"), .feature)
        XCTAssertEqual(CommitInfo.CommitType.from("fix: bug fix"), .fix)
        XCTAssertEqual(CommitInfo.CommitType.from("docs: update readme"), .docs)
        XCTAssertEqual(CommitInfo.CommitType.from("random message"), .other)
    }
    
    func testProjectInfo() {
        let project = ProjectInfo(name: "Test", description: "Desc", version: "2.0.0", author: "Author", license: "MIT", features: ["A", "B"], dependencies: ["Dep1"])
        
        XCTAssertEqual(project.name, "Test")
        XCTAssertEqual(project.version, "2.0.0")
        XCTAssertEqual(project.features.count, 2)
        XCTAssertEqual(project.dependencies.count, 1)
    }
    
    func testCodeSymbol() {
        let param = CodeSymbol.ParameterInfo(name: "value", type: "Int", description: "The value")
        let symbol = CodeSymbol(name: "calculate", type: .function, signature: "func calculate(value: Int) -> Int", parameters: [param], returnType: "Int")
        
        XCTAssertEqual(symbol.name, "calculate")
        XCTAssertEqual(symbol.type, .function)
        XCTAssertEqual(symbol.parameters.count, 1)
        XCTAssertEqual(symbol.returnType, "Int")
    }
}
