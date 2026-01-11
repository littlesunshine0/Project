import Testing
@testable import IndexerKit

@Suite("IndexerKit Tests")
struct IndexerKitTests {
    
    @Test("Index code file")
    func testIndexCodeFile() async {
        let code = """
        import Foundation
        
        public struct MyStruct {
            func myMethod() { }
        }
        
        class MyClass { }
        """
        let indexed = await CodeIndexer.shared.index(file: "/test/file.swift", content: code, language: "swift")
        #expect(indexed.language == "swift")
        #expect(!indexed.symbols.isEmpty)
        #expect(indexed.imports.contains("Foundation"))
    }
    
    @Test("Find symbol")
    func testFindSymbol() async {
        let code = "func uniqueFunction123() { }"
        _ = await CodeIndexer.shared.index(file: "/test/unique.swift", content: code, language: "swift")
        let files = await CodeIndexer.shared.findSymbol("uniqueFunction123")
        #expect(files.contains("/test/unique.swift"))
    }
    
    @Test("Find import")
    func testFindImport() async {
        let code = "import SwiftUI\nstruct View { }"
        _ = await CodeIndexer.shared.index(file: "/test/view.swift", content: code, language: "swift")
        let files = await CodeIndexer.shared.findImport("SwiftUI")
        #expect(files.contains("/test/view.swift"))
    }
    
    @Test("Index document")
    func testIndexDocument() async {
        let content = "This is a test document with searchable content about Swift programming."
        let indexed = await DocumentIndexer.shared.index(document: "/docs/test.md", content: content, title: "Test Doc", tags: ["swift", "tutorial"])
        #expect(indexed.title == "Test Doc")
        #expect(indexed.tags.contains("swift"))
    }
    
    @Test("Search documents")
    func testSearchDocuments() async {
        let content = "Unique keyword xyz789 in this document"
        _ = await DocumentIndexer.shared.index(document: "/docs/search.md", content: content, title: "Search Test")
        let results = await DocumentIndexer.shared.search("xyz789")
        #expect(!results.isEmpty)
    }
    
    @Test("Find by tag")
    func testFindByTag() async {
        _ = await DocumentIndexer.shared.index(document: "/docs/tagged.md", content: "Content", title: "Tagged", tags: ["important"])
        let results = await DocumentIndexer.shared.findByTag("important")
        #expect(!results.isEmpty)
    }
    
    @Test("Scan asset")
    func testScanAsset() async {
        let asset = await AssetScanner.shared.scan(path: "/assets/image.png", type: .image, size: 1024)
        #expect(asset.type == .image)
        #expect(asset.size == 1024)
    }
    
    @Test("Get assets by type")
    func testGetAssetsByType() async {
        _ = await AssetScanner.shared.scan(path: "/assets/video.mp4", type: .video, size: 5000)
        let videos = await AssetScanner.shared.getByType(.video)
        #expect(!videos.isEmpty)
    }
    
    @Test("Indexer stats")
    func testIndexerStats() async {
        let stats = await CodeIndexer.shared.stats
        #expect(stats.fileCount >= 0)
    }
}
