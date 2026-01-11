//
//  ContentHubTests.swift
//  ContentHub
//

import XCTest
@testable import ContentHub

final class ContentHubTests: XCTestCase {
    
    func testGeneratedContent() {
        let content = GeneratedContent(
            projectId: "proj-1",
            projectName: "TestProject",
            type: .readme,
            title: "README",
            content: "# Test Project",
            generatedBy: "DocKit"
        )
        
        XCTAssertEqual(content.projectName, "TestProject")
        XCTAssertEqual(content.type, .readme)
        XCTAssertEqual(content.fileName, "readme.md")
    }
    
    func testContentTypes() {
        XCTAssertEqual(ContentType.readme.fileExtension, "md")
        XCTAssertEqual(ContentType.commands.fileExtension, "json")
        XCTAssertEqual(ContentType.readme.category, .documentation)
        XCTAssertEqual(ContentType.workflows.category, .configuration)
    }
    
    func testContentMetadata() {
        let metadata = ContentMetadata(
            tags: ["swift", "ios"],
            dependencies: ["Foundation"],
            wordCount: 100
        )
        
        XCTAssertEqual(metadata.tags.count, 2)
        XCTAssertEqual(metadata.wordCount, 100)
    }
    
    func testContentFilters() {
        var filters = ContentFilters()
        filters.types = [.readme, .design]
        filters.maxResults = 50
        
        XCTAssertEqual(filters.types?.count, 2)
        XCTAssertEqual(filters.maxResults, 50)
    }
    
    func testProjectRegistration() {
        let registration = ProjectRegistration(
            projectId: "proj-1",
            projectName: "TestProject",
            projectPath: "/path/to/project",
            attachedKits: ["DocKit", "SearchKit"]
        )
        
        XCTAssertEqual(registration.projectName, "TestProject")
        XCTAssertEqual(registration.attachedKits.count, 2)
    }
    
    func testHubStatistics() {
        let stats = HubStatistics(
            totalContent: 100,
            totalProjects: 10,
            contentByType: [.readme: 10, .design: 5],
            totalSize: 50000
        )
        
        XCTAssertEqual(stats.totalContent, 100)
        XCTAssertEqual(stats.totalProjects, 10)
    }
    
    func testMLTrainingRecord() {
        let content = GeneratedContent(
            projectId: "proj-1",
            projectName: "TestProject",
            type: .readme,
            title: "README",
            content: "# Test",
            metadata: ContentMetadata(tags: ["swift"]),
            generatedBy: "DocKit"
        )
        
        let record = MLTrainingRecord(from: content)
        
        XCTAssertEqual(record.projectName, "TestProject")
        XCTAssertEqual(record.type, .readme)
        XCTAssertEqual(record.tags, ["swift"])
    }
    
    func testContentResult() {
        let content = GeneratedContent(
            projectId: "proj-1",
            projectName: "TestProject",
            type: .readme,
            title: "README",
            content: "# Test",
            generatedBy: "DocKit"
        )
        
        let result = ContentResult(content: content, relevance: 85.0, highlights: ["Title match"])
        
        XCTAssertEqual(result.relevance, 85.0)
        XCTAssertEqual(result.highlights.count, 1)
    }
    
    func testAllContentTypes() {
        let types = ContentType.allCases
        XCTAssertTrue(types.count >= 15)
        
        for type in types {
            XCTAssertFalse(type.fileExtension.isEmpty)
        }
    }
    
    func testContentCategories() {
        let categories = ContentCategory.allCases
        XCTAssertEqual(categories.count, 4)
        XCTAssertTrue(categories.contains(.documentation))
        XCTAssertTrue(categories.contains(.configuration))
    }
}
