//
//  KnowledgeIngestionPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for knowledge ingestion engine
//

import XCTest
@testable import Project

class KnowledgeIngestionPropertyTests: XCTestCase {
    
    var ingestionEngine: KnowledgeIngestionEngine!
    var documentIndex: DocumentIndex!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create test database in memory
        let testDB = DocumentationDatabase(path: ":memory:")
        try testDB.open()
        
        documentIndex = DocumentIndex(database: testDB)
        try await documentIndex.initialize()
        
        ingestionEngine = KnowledgeIngestionEngine(documentIndex: documentIndex)
    }
    
    override func tearDown() async throws {
        ingestionEngine = nil
        documentIndex = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 70: Documentation ingestion round trip
    // **Feature: workflow-assistant-app, Property 70: Documentation ingestion round trip**
    // **Validates: Requirements 18.1, 18.3, 18.5**
    
    func testProperty70_IngestionRoundTrip() async throws {
        // Test with multiple formats
        let testCases = [
            (format: DocumentFormat.html, content: generateHTMLContent()),
            (format: DocumentFormat.markdown, content: generateMarkdownContent()),
            (format: DocumentFormat.plainText, content: generatePlainTextContent())
        ]
        
        for (index, testCase) in testCases.enumerated() {
            // Parse content
            let structured = try await ingestionEngine.parseContent(testCase.content, format: testCase.format)
            
            // Verify structured document is not empty
            XCTAssertFalse(structured.sections.isEmpty, 
                          "Parsed document should have sections for format \(testCase.format)")
            
            // Create documentation entry
            let url = URL(string: "https://example.com/doc\(index)")!
            let entry = DocumentationEntry(
                url: url,
                title: "Test Document \(index)",
                content: structured,
                workflows: [],
                indexedAt: Date()
            )
            
            // Index the document
            try await documentIndex.indexDocument(entry)
            
            // Search for content from the document
            let searchQuery = extractSearchableText(from: structured)
            let results = try await documentIndex.search(query: searchQuery, limit: 10)
            
            // Verify the document is searchable
            XCTAssertTrue(results.contains(where: { $0.url == url }),
                         "Ingested document should be searchable for format \(testCase.format)")
        }
    }
    
    // MARK: - Property 71: Structured extraction completeness
    // **Feature: workflow-assistant-app, Property 71: Structured extraction completeness**
    // **Validates: Requirements 18.2**
    
    func testProperty71_StructuredExtractionCompleteness() async throws {
        // Test HTML with headings, code, and API references
        let htmlContent = """
        <html>
        <head><title>API Documentation</title></head>
        <body>
            <h1>Getting Started</h1>
            <p>This is the introduction to our API.</p>
            
            <h2>Installation</h2>
            <p>Install using the following command:</p>
            <pre><code>npm install example-api</code></pre>
            
            <h2>Usage</h2>
            <p>Here's how to use the API:</p>
            <code>function fetchData(url) { return fetch(url); }</code>
            
            <h3>Authentication</h3>
            <p>Use API keys for authentication.</p>
        </body>
        </html>
        """
        
        let structured = try await ingestionEngine.parseContent(htmlContent, format: .html)
        
        // Verify headings are extracted
        XCTAssertTrue(structured.sections.count >= 3, 
                     "Should extract multiple sections from headings")
        
        // Verify at least one section has content
        XCTAssertTrue(structured.sections.contains(where: { !$0.content.isEmpty }),
                     "Sections should have content")
        
        // Verify code examples are extracted
        XCTAssertFalse(structured.codeExamples.isEmpty,
                      "Should extract code examples from HTML")
        
        // Test Markdown with similar structure
        let markdownContent = """
        # Getting Started
        
        This is the introduction to our API.
        
        ## Installation
        
        Install using the following command:
        
        ```bash
        npm install example-api
        ```
        
        ## Usage
        
        Here's how to use the API:
        
        ```javascript
        function fetchData(url) {
            return fetch(url);
        }
        ```
        
        ### Authentication
        
        Use API keys for authentication.
        """
        
        let markdownStructured = try await ingestionEngine.parseContent(markdownContent, format: .markdown)
        
        // Verify headings are extracted
        XCTAssertTrue(markdownStructured.sections.count >= 3,
                     "Should extract multiple sections from Markdown headings")
        
        // Verify code blocks are extracted
        XCTAssertTrue(markdownStructured.codeExamples.count >= 2,
                     "Should extract code blocks from Markdown")
        
        // Verify code language is detected
        XCTAssertTrue(markdownStructured.codeExamples.contains(where: { $0.language == "bash" }),
                     "Should detect bash language in code blocks")
    }
    
    // MARK: - Property 72: Multi-format support
    // **Feature: workflow-assistant-app, Property 72: Multi-format support**
    // **Validates: Requirements 18.4**
    
    func testProperty72_MultiFormatSupport() async throws {
        let formats: [DocumentFormat] = [.html, .markdown, .plainText]
        
        for format in formats {
            let content = generateContentForFormat(format)
            
            do {
                let structured = try await ingestionEngine.parseContent(content, format: format)
                
                // Verify parsing succeeded
                XCTAssertFalse(structured.sections.isEmpty,
                              "Should successfully parse \(format) format")
                
                // Verify sections have content
                XCTAssertTrue(structured.sections.contains(where: { !$0.content.isEmpty }),
                             "Parsed \(format) should have content in sections")
                
            } catch {
                XCTFail("Failed to parse \(format) format: \(error)")
            }
        }
        
        // Test OpenAPI/JSON format
        let openAPIContent = """
        {
            "openapi": "3.0.0",
            "info": {
                "title": "Test API",
                "version": "1.0.0",
                "description": "A test API specification"
            },
            "paths": {
                "/users": {
                    "get": {
                        "summary": "Get all users",
                        "description": "Returns a list of users",
                        "responses": {
                            "200": {
                                "description": "Successful response"
                            }
                        }
                    }
                }
            }
        }
        """
        
        do {
            let structured = try await ingestionEngine.parseContent(openAPIContent, format: .openAPI)
            
            // Verify OpenAPI parsing
            XCTAssertFalse(structured.sections.isEmpty,
                          "Should successfully parse OpenAPI format")
            
            // Verify API references are extracted
            XCTAssertFalse(structured.apiReferences.isEmpty,
                          "Should extract API references from OpenAPI spec")
            
        } catch {
            XCTFail("Failed to parse OpenAPI format: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func generateHTMLContent() -> String {
        return """
        <html>
        <head><title>Test Document</title></head>
        <body>
            <h1>Main Heading</h1>
            <p>This is a test paragraph with some content.</p>
            <h2>Subheading</h2>
            <p>More content here.</p>
            <code>let x = 42</code>
        </body>
        </html>
        """
    }
    
    private func generateMarkdownContent() -> String {
        return """
        # Main Heading
        
        This is a test paragraph with some content.
        
        ## Subheading
        
        More content here.
        
        ```swift
        let x = 42
        ```
        """
    }
    
    private func generatePlainTextContent() -> String {
        return """
        Main Heading
        
        This is a test paragraph with some content.
        
        Subheading
        
        More content here.
        """
    }
    
    private func generateContentForFormat(_ format: DocumentFormat) -> String {
        switch format {
        case .html:
            return generateHTMLContent()
        case .markdown:
            return generateMarkdownContent()
        case .plainText:
            return generatePlainTextContent()
        case .openAPI, .json:
            return "{}"
        }
    }
    
    private func extractSearchableText(from document: StructuredDocument) -> String {
        // Extract first non-empty section title or content for searching
        if let firstSection = document.sections.first {
            let words = firstSection.title.components(separatedBy: .whitespaces)
            return words.first ?? "test"
        }
        return "test"
    }
}
