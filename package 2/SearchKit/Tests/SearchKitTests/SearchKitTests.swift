//
//  SearchKitTests.swift
//  SearchKit
//

import XCTest
@testable import SearchKit

final class SearchKitTests: XCTestCase {
    
    override func setUp() async throws {
        await SearchIndex.shared.clear()
    }
    
    func testIndexAndSearch() async {
        let item = SearchableItem(type: .document, title: "Swift Guide", content: "Learn Swift programming")
        await SearchKit.index(item)
        
        let results = await SearchKit.search("Swift")
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertEqual(results.first?.title, "Swift Guide")
    }
    
    func testQuickSearch() async {
        for i in 0..<20 {
            await SearchKit.index(SearchableItem(type: .document, title: "Doc \(i)", content: "Content \(i)"))
        }
        
        let results = await SearchKit.quickSearch("Doc")
        
        XCTAssertEqual(results.count, 10) // Quick search returns max 10
    }
    
    func testRelevanceCalculation() {
        // Exact title match should score highest
        let exactMatch = SearchKit.relevance(query: "swift", title: "swift", content: "")
        let partialMatch = SearchKit.relevance(query: "swift", title: "swift guide", content: "")
        let contentOnly = SearchKit.relevance(query: "swift", title: "guide", content: "learn swift")
        
        XCTAssertGreaterThan(exactMatch, partialMatch)
        XCTAssertGreaterThan(partialMatch, contentOnly)
    }
    
    func testSearchFilters() async {
        await SearchKit.index(SearchableItem(type: .documentation, title: "API Docs", content: "API"))
        await SearchKit.index(SearchableItem(type: .code, title: "Code File", content: "API"))
        
        var filters = SearchFilters()
        filters.includeCode = false
        
        let results = await SearchKit.search("API", filters: filters)
        
        XCTAssertTrue(results.allSatisfy { $0.type != .code })
    }
    
    func testSearchResult() {
        let result = SearchResult(type: .document, title: "Test", subtitle: "Sub", content: "Content", path: "/test", relevance: 50.0, metadata: ["key": "value"])
        
        XCTAssertEqual(result.type, .document)
        XCTAssertEqual(result.title, "Test")
        XCTAssertEqual(result.relevance, 50.0)
        XCTAssertEqual(result.metadata["key"], "value")
    }
    
    func testSearchableItem() {
        let item = SearchableItem(type: .workflow, title: "Build", content: "Build project", path: "/workflows/build", metadata: ["category": "dev"])
        
        XCTAssertEqual(item.type, .workflow)
        XCTAssertEqual(item.title, "Build")
        XCTAssertEqual(item.path, "/workflows/build")
    }
    
    func testAllResultTypes() {
        let types: [SearchResult.ResultType] = [.documentation, .document, .code, .asset, .workflow, .project, .template, .command, .file]
        XCTAssertEqual(types.count, 9)
    }
    
    func testEmptySearch() async {
        let results = await SearchKit.search("")
        XCTAssertTrue(results.isEmpty)
    }
    
    func testLowRelevance() async {
        // Test that relevance is low for unrelated query (only gets short content bonus)
        let relevance = SearchKit.relevance(query: "python", title: "Swift", content: "Swift programming")
        // Only gets the short content bonus (10.0), no match bonuses
        XCTAssertEqual(relevance, 10.0)
    }
}
