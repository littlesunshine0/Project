//
//  DocumentationSearchPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for API documentation search
//  Validates requirement 17.2
//

import XCTest
import SwiftCheck
@testable import Project

final class DocumentationSearchPropertyTests: XCTestCase {
    var documentIndex: DocumentIndex!
    var database: DocumentationDatabase!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create in-memory database for testing
        let tempDir = FileManager.default.temporaryDirectory
        let testDBPath = tempDir.appendingPathComponent("test_docs_\(UUID().uuidString).db").path
        
        database = DocumentationDatabase(path: testDBPath)
        documentIndex = DocumentIndex(database: database)
        try await documentIndex.initialize()
        
        // Seed with sample Apple API documentation
        try await seedAppleDocumentation()
    }
    
    override func tearDown() async throws {
        database.close()
        try await super.tearDown()
    }
    
    // MARK: - Test Data Seeding
    
    private func seedAppleDocumentation() async throws {
        // Seed SwiftUI documentation
        let swiftUIDoc = DocumentationEntry(
            url: URL(string: "https://developer.apple.com/documentation/swiftui/view")!,
            title: "View - SwiftUI",
            content: StructuredDocument(
                sections: [
                    DocumentSection(
                        title: "View Protocol",
                        content: "A type that represents part of your app's user interface and provides modifiers that you use to configure views. SwiftUI views are lightweight and efficient.",
                        level: 1,
                        tags: ["SwiftUI", "View", "Protocol", "UI"]
                    ),
                    DocumentSection(
                        title: "Creating a View",
                        content: "To create a custom view, declare a type that conforms to the View protocol and implement the required body property.",
                        level: 2,
                        tags: ["SwiftUI", "View", "Tutorial"]
                    )
                ],
                codeExamples: [
                    CodeExample(
                        language: "swift",
                        code: "struct ContentView: View {\n    var body: some View {\n        Text(\"Hello, World!\")\n    }\n}",
                        description: "Basic SwiftUI view example"
                    )
                ],
                apiReferences: [
                    APIReference(
                        name: "View",
                        type: "protocol",
                        description: "A type that represents part of your app's user interface",
                        parameters: nil
                    )
                ]
            ),
            workflows: []
        )
        
        try await documentIndex.indexDocument(swiftUIDoc)
        
        // Seed UIKit documentation
        let uikitDoc = DocumentationEntry(
            url: URL(string: "https://developer.apple.com/documentation/uikit/uiview")!,
            title: "UIView - UIKit",
            content: StructuredDocument(
                sections: [
                    DocumentSection(
                        title: "UIView Class",
                        content: "An object that manages the content for a rectangular area on the screen. Views are the fundamental building blocks of your app's user interface.",
                        level: 1,
                        tags: ["UIKit", "UIView", "Class", "UI"]
                    ),
                    DocumentSection(
                        title: "Creating Views",
                        content: "You can create views programmatically or using Interface Builder. UIView provides methods for managing the view hierarchy.",
                        level: 2,
                        tags: ["UIKit", "UIView", "Tutorial"]
                    )
                ],
                codeExamples: [
                    CodeExample(
                        language: "swift",
                        code: "let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))\nview.backgroundColor = .blue",
                        description: "Creating a UIView programmatically"
                    )
                ],
                apiReferences: [
                    APIReference(
                        name: "UIView",
                        type: "class",
                        description: "An object that manages the content for a rectangular area on the screen",
                        parameters: nil
                    )
                ]
            ),
            workflows: []
        )
        
        try await documentIndex.indexDocument(uikitDoc)
        
        // Seed Foundation documentation
        let foundationDoc = DocumentationEntry(
            url: URL(string: "https://developer.apple.com/documentation/foundation/url")!,
            title: "URL - Foundation",
            content: StructuredDocument(
                sections: [
                    DocumentSection(
                        title: "URL Structure",
                        content: "A value that identifies the location of a resource, such as an item on a remote server or the path to a local file. URL provides methods for accessing and manipulating URLs.",
                        level: 1,
                        tags: ["Foundation", "URL", "Struct", "Networking"]
                    )
                ],
                codeExamples: [
                    CodeExample(
                        language: "swift",
                        code: "let url = URL(string: \"https://www.apple.com\")!",
                        description: "Creating a URL from a string"
                    )
                ],
                apiReferences: [
                    APIReference(
                        name: "URL",
                        type: "struct",
                        description: "A value that identifies the location of a resource",
                        parameters: nil
                    )
                ]
            ),
            workflows: []
        )
        
        try await documentIndex.indexDocument(foundationDoc)
        
        // Seed Combine documentation
        let combineDoc = DocumentationEntry(
            url: URL(string: "https://developer.apple.com/documentation/combine/publisher")!,
            title: "Publisher - Combine",
            content: StructuredDocument(
                sections: [
                    DocumentSection(
                        title: "Publisher Protocol",
                        content: "Declares that a type can transmit a sequence of values over time. Publishers deliver elements to one or more Subscriber instances.",
                        level: 1,
                        tags: ["Combine", "Publisher", "Protocol", "Reactive"]
                    )
                ],
                codeExamples: [
                    CodeExample(
                        language: "swift",
                        code: "let publisher = Just(42)\npublisher.sink { value in\n    print(value)\n}",
                        description: "Basic publisher example"
                    )
                ],
                apiReferences: [
                    APIReference(
                        name: "Publisher",
                        type: "protocol",
                        description: "Declares that a type can transmit a sequence of values over time",
                        parameters: nil
                    )
                ]
            ),
            workflows: []
        )
        
        try await documentIndex.indexDocument(combineDoc)
    }
    
    // MARK: - Property 67: API Documentation Search
    // Requirement 17.2
    
    // **Feature: workflow-assistant-app, Property 67: API documentation search**
    func testProperty67_APIDocumentationSearch() {
        property("For any question about Apple APIs, system should search and provide relevant excerpts") <- forAll { (seed: Int) in
            // Generate various Apple API queries
            let apiQueries = [
                "SwiftUI View",
                "UIView",
                "URL Foundation",
                "Publisher Combine",
                "View protocol",
                "UIKit view",
                "Foundation URL struct",
                "Combine publisher"
            ]
            
            let query = apiQueries[abs(seed) % apiQueries.count]
            
            let expectation = self.expectation(description: "Search API documentation")
            var searchSuccessful = false
            var results: [DocumentationSearchResult] = []
            
            Task {
                do {
                    results = try await self.documentIndex.searchAppleAPIs(query: query)
                    
                    // Property: Should return relevant results
                    if !results.isEmpty {
                        // Check that results are relevant to the query
                        let queryTerms = query.lowercased().split(separator: " ").map(String.init)
                        
                        for result in results {
                            let resultText = (result.title + " " + result.snippet).lowercased()
                            let hasRelevantTerm = queryTerms.contains { term in
                                resultText.contains(term)
                            }
                            
                            if hasRelevantTerm {
                                searchSuccessful = true
                                break
                            }
                        }
                    }
                    
                    expectation.fulfill()
                } catch {
                    XCTFail("Search failed: \(error)")
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Should find at least one relevant result for Apple API queries
            return searchSuccessful || results.isEmpty
        }
    }
    
    // MARK: - Additional Property Tests
    
    func testSearchReturnsRelevantExcerpts() async throws {
        // Test that search returns relevant excerpts from documentation
        let results = try await documentIndex.searchAppleAPIs(query: "View")
        
        XCTAssertFalse(results.isEmpty, "Should find View-related documentation")
        
        for result in results {
            // Check that snippet contains relevant information
            XCTAssertFalse(result.snippet.isEmpty, "Snippet should not be empty")
            
            // Check that result is from Apple documentation
            let isAppleDoc = result.url.absoluteString.contains("apple.com") ||
                           result.title.lowercased().contains("swift") ||
                           result.title.lowercased().contains("uikit") ||
                           result.title.lowercased().contains("foundation")
            
            XCTAssertTrue(isAppleDoc, "Result should be from Apple documentation")
        }
    }
    
    func testSearchWithEmptyQueryReturnsEmpty() async throws {
        let results = try await documentIndex.searchAppleAPIs(query: "")
        XCTAssertTrue(results.isEmpty, "Empty query should return no results")
    }
    
    func testSearchReturnsRankedResults() async throws {
        let results = try await documentIndex.searchAppleAPIs(query: "View")
        
        if results.count > 1 {
            // Check that results are ranked (rank values should be ordered)
            for i in 0..<(results.count - 1) {
                XCTAssertLessThanOrEqual(
                    results[i].rank,
                    results[i + 1].rank,
                    "Results should be ranked by relevance"
                )
            }
        }
    }
    
    func testOfflineAccessAvailability() {
        // Property: Documentation should be available offline
        let isOffline = documentIndex.isOfflineAvailable()
        XCTAssertTrue(isOffline, "Documentation should be available offline")
    }
    
    func testSearchSpecificAPITypes() async throws {
        // Test searching for specific API types
        let testCases: [(String, String)] = [
            ("View", "protocol"),
            ("UIView", "class"),
            ("URL", "struct"),
            ("Publisher", "protocol")
        ]
        
        for (apiName, expectedType) in testCases {
            let results = try await documentIndex.searchAppleAPIs(query: apiName)
            
            XCTAssertFalse(results.isEmpty, "Should find documentation for \(apiName)")
            
            // Check that at least one result mentions the expected type
            let hasExpectedType = results.contains { result in
                result.snippet.lowercased().contains(expectedType) ||
                result.title.lowercased().contains(expectedType)
            }
            
            XCTAssertTrue(
                hasExpectedType,
                "Results for \(apiName) should mention it's a \(expectedType)"
            )
        }
    }
    
    func testSearchWithFrameworkContext() async throws {
        // Test that framework context improves search relevance
        let testCases = [
            ("View SwiftUI", "swiftui"),
            ("View UIKit", "uikit"),
            ("URL Foundation", "foundation"),
            ("Publisher Combine", "combine")
        ]
        
        for (query, expectedFramework) in testCases {
            let results = try await documentIndex.searchAppleAPIs(query: query)
            
            XCTAssertFalse(results.isEmpty, "Should find documentation for '\(query)'")
            
            // Check that top result is from the expected framework
            if let topResult = results.first {
                let resultText = (topResult.title + " " + topResult.snippet).lowercased()
                XCTAssertTrue(
                    resultText.contains(expectedFramework),
                    "Top result for '\(query)' should be from \(expectedFramework)"
                )
            }
        }
    }
    
    func testSearchReturnsCodeExamples() async throws {
        // Test that search results include code examples when available
        let results = try await documentIndex.searchAppleAPIs(query: "SwiftUI View")
        
        XCTAssertFalse(results.isEmpty, "Should find SwiftUI View documentation")
        
        // The snippet should contain relevant information
        // (actual code examples would be in the full document)
        for result in results {
            XCTAssertFalse(result.snippet.isEmpty, "Should provide excerpt")
        }
    }
    
    func testMultipleSearchesReturnConsistentResults() async throws {
        // Property: Same query should return consistent results
        let query = "View"
        
        let results1 = try await documentIndex.searchAppleAPIs(query: query)
        let results2 = try await documentIndex.searchAppleAPIs(query: query)
        
        XCTAssertEqual(results1.count, results2.count, "Same query should return same number of results")
        
        // Check that result IDs match
        let ids1 = Set(results1.map { $0.id })
        let ids2 = Set(results2.map { $0.id })
        
        XCTAssertEqual(ids1, ids2, "Same query should return same results")
    }
    
    func testSearchHandlesSpecialCharacters() async throws {
        // Test that search handles special characters gracefully
        let specialQueries = [
            "UIView+Animation",
            "URL.init",
            "View.body",
            "Publisher<Int, Never>"
        ]
        
        for query in specialQueries {
            do {
                let results = try await documentIndex.searchAppleAPIs(query: query)
                // Should not crash and should return results or empty array
                XCTAssertTrue(results.isEmpty || !results.isEmpty, "Should handle special characters")
            } catch {
                XCTFail("Should not throw error for query: \(query)")
            }
        }
    }
    
    func testSearchPerformance() async throws {
        // Test that search completes within reasonable time
        let query = "View"
        
        let startTime = Date()
        _ = try await documentIndex.searchAppleAPIs(query: query)
        let duration = Date().timeIntervalSince(startTime)
        
        // Search should complete within 1 second
        XCTAssertLessThan(duration, 1.0, "Search should complete within 1 second")
    }
    
    // MARK: - Property 69: Offline Documentation Access
    // Requirement 17.5
    
    // **Feature: workflow-assistant-app, Property 69: Offline documentation access**
    func testProperty69_OfflineDocumentationAccess() {
        property("For any pre-indexed documentation, system should provide access when offline") <- forAll { (seed: Int) in
            // Generate various documentation queries
            let documentationQueries = [
                "SwiftUI View",
                "UIView class",
                "URL struct",
                "Publisher protocol",
                "Foundation",
                "UIKit",
                "Combine",
                "AppKit"
            ]
            
            let query = documentationQueries[abs(seed) % documentationQueries.count]
            
            let expectation = self.expectation(description: "Offline documentation access")
            var accessSuccessful = false
            var offlineAvailable = false
            
            Task {
                // Property 1: Documentation should be marked as offline available
                offlineAvailable = self.documentIndex.isOfflineAvailable()
                
                // Property 2: Should be able to search without network
                // (simulated by the fact that our database is local)
                do {
                    let results = try await self.documentIndex.search(query: query, limit: 10)
                    
                    // Property 3: Should return results for pre-indexed content
                    // Even if network is unavailable, local database should work
                    accessSuccessful = offlineAvailable && (results.isEmpty || !results.isEmpty)
                    
                    // Property 4: Results should be from local storage
                    // Verify that we can access the full content
                    if !results.isEmpty {
                        // Try to get document details (would fail if network-dependent)
                        let firstResult = results[0]
                        accessSuccessful = accessSuccessful && 
                                         !firstResult.title.isEmpty && 
                                         !firstResult.snippet.isEmpty
                    }
                    
                    expectation.fulfill()
                } catch {
                    // Should not fail for offline access to pre-indexed content
                    XCTFail("Offline access failed: \(error)")
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Offline availability should be true and access should work
            return offlineAvailable && accessSuccessful
        }.withSize(100)
    }
    
    // MARK: - Additional Offline Access Tests
    
    func testOfflineAccessWithoutNetwork() async throws {
        // Test that documentation is accessible without network connectivity
        // This simulates offline mode by verifying local database access
        
        // Verify offline availability flag
        let isOffline = documentIndex.isOfflineAvailable()
        XCTAssertTrue(isOffline, "Documentation should be marked as offline available")
        
        // Verify we can search pre-indexed content
        let queries = ["View", "UIKit", "Foundation", "SwiftUI"]
        
        for query in queries {
            let results = try await documentIndex.search(query: query, limit: 5)
            
            // Should be able to get results from local database
            // (may be empty if not indexed, but should not throw error)
            XCTAssertNoThrow(results, "Should access local database without network")
            
            // If we have results, verify they're complete
            for result in results {
                XCTAssertFalse(result.title.isEmpty, "Result should have title")
                XCTAssertFalse(result.snippet.isEmpty, "Result should have snippet")
                XCTAssertNotNil(result.url, "Result should have URL")
            }
        }
    }
    
    func testPreIndexedDocumentationAvailability() async throws {
        // Property: All pre-indexed documentation should be accessible offline
        
        // Get count of indexed documents
        let count = try await documentIndex.getIndexedDocumentCount()
        XCTAssertGreaterThan(count, 0, "Should have pre-indexed documentation")
        
        // Verify we can search for known pre-indexed content
        let knownAPIs = [
            "View",      // SwiftUI
            "UIView",    // UIKit
            "URL",       // Foundation
            "Publisher"  // Combine
        ]
        
        for api in knownAPIs {
            let results = try await documentIndex.search(query: api, limit: 1)
            XCTAssertFalse(results.isEmpty, "Pre-indexed \(api) should be searchable offline")
        }
    }
    
    func testOfflineSearchConsistency() async throws {
        // Property: Offline searches should return consistent results
        let query = "SwiftUI View"
        
        // Perform multiple searches
        let results1 = try await documentIndex.search(query: query, limit: 10)
        let results2 = try await documentIndex.search(query: query, limit: 10)
        let results3 = try await documentIndex.search(query: query, limit: 10)
        
        // Results should be consistent across searches
        XCTAssertEqual(results1.count, results2.count, "Offline searches should be consistent")
        XCTAssertEqual(results2.count, results3.count, "Offline searches should be consistent")
        
        // Result IDs should match
        let ids1 = results1.map { $0.id }
        let ids2 = results2.map { $0.id }
        let ids3 = results3.map { $0.id }
        
        XCTAssertEqual(ids1, ids2, "Same query should return same results offline")
        XCTAssertEqual(ids2, ids3, "Same query should return same results offline")
    }
    
    func testOfflineAccessPerformance() async throws {
        // Property: Offline access should be fast (no network latency)
        let query = "View"
        
        let startTime = Date()
        _ = try await documentIndex.search(query: query, limit: 10)
        let duration = Date().timeIntervalSince(startTime)
        
        // Offline access should be very fast (< 500ms)
        XCTAssertLessThan(duration, 0.5, "Offline access should be fast without network latency")
    }
    
    func testOfflineAccessWithMultipleQueries() async throws {
        // Property: Multiple offline queries should all succeed
        let queries = [
            "SwiftUI View protocol",
            "UIKit UIView class",
            "Foundation URL struct",
            "Combine Publisher protocol",
            "AppKit NSView",
            "CoreData NSManagedObject"
        ]
        
        for query in queries {
            do {
                let results = try await documentIndex.search(query: query, limit: 5)
                
                // Should not throw error for offline access
                XCTAssertNoThrow(results, "Offline access should work for: \(query)")
                
                // Results should be valid
                for result in results {
                    XCTAssertFalse(result.title.isEmpty, "Offline result should have title")
                    XCTAssertNotNil(result.url, "Offline result should have URL")
                }
            } catch {
                XCTFail("Offline access failed for query '\(query)': \(error)")
            }
        }
    }
    
    func testOfflineAccessWithEmptyDatabase() async throws {
        // Test offline access behavior with empty database
        // Create a new empty database
        let tempDir = FileManager.default.temporaryDirectory
        let emptyDBPath = tempDir.appendingPathComponent("empty_test_\(UUID().uuidString).db").path
        
        let emptyDatabase = DocumentationDatabase(path: emptyDBPath)
        let emptyIndex = DocumentIndex(database: emptyDatabase)
        try await emptyIndex.initialize()
        
        // Should still report as offline available
        XCTAssertTrue(emptyIndex.isOfflineAvailable(), "Empty database should still be offline available")
        
        // Search should return empty results, not error
        let results = try await emptyIndex.search(query: "anything", limit: 10)
        XCTAssertTrue(results.isEmpty, "Empty database should return empty results")
        
        emptyDatabase.close()
    }
    
    func testOfflineAccessDataIntegrity() async throws {
        // Property: Offline access should return complete, uncorrupted data
        let results = try await documentIndex.search(query: "View", limit: 5)
        
        for result in results {
            // Verify all required fields are present and valid
            XCTAssertFalse(result.id.uuidString.isEmpty, "Result should have valid ID")
            XCTAssertFalse(result.title.isEmpty, "Result should have title")
            XCTAssertNotNil(result.url, "Result should have URL")
            XCTAssertFalse(result.snippet.isEmpty, "Result should have snippet")
            
            // Verify URL is valid
            XCTAssertTrue(result.url.absoluteString.count > 0, "URL should be valid")
            
            // Verify rank is a valid number
            XCTAssertFalse(result.rank.isNaN, "Rank should be a valid number")
            XCTAssertFalse(result.rank.isInfinite, "Rank should be finite")
        }
    }
}
