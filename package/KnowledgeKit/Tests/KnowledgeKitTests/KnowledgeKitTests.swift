import Testing
@testable import KnowledgeKit

@Suite("KnowledgeKit Tests")
struct KnowledgeKitTests {
    
    @Test("Add knowledge entry")
    func testAddEntry() async {
        let id = await KnowledgeBase.shared.add(title: "Test Entry", content: "Test content", category: .general)
        let entry = await KnowledgeBase.shared.get(id)
        #expect(entry != nil)
        #expect(entry?.title == "Test Entry")
    }
    
    @Test("Search knowledge")
    func testSearch() async {
        _ = await KnowledgeBase.shared.add(title: "Swift Guide", content: "Learn Swift programming language")
        let results = await KnowledgeBase.shared.search("Swift programming")
        #expect(!results.isEmpty)
    }
    
    @Test("Get by tag")
    func testGetByTag() async {
        _ = await KnowledgeBase.shared.add(title: "Tagged Entry", content: "Content", tags: ["important", "tutorial"])
        let results = await KnowledgeBase.shared.getByTag("important")
        #expect(!results.isEmpty)
    }
    
    @Test("Get by category")
    func testGetByCategory() async {
        _ = await KnowledgeBase.shared.add(title: "API Doc", content: "API documentation", category: .api)
        let results = await KnowledgeBase.shared.getByCategory(.api)
        #expect(!results.isEmpty)
    }
    
    @Test("Ingest text")
    func testIngestText() async {
        let id = await KnowledgeIngestion.shared.ingestText("Sample text content", title: "Sample")
        let entry = await KnowledgeBase.shared.get(id)
        #expect(entry != nil)
    }
    
    @Test("Ingest markdown")
    func testIngestMarkdown() async {
        let markdown = "# Header\n\nContent here\n\n## Subheader"
        let id = await KnowledgeIngestion.shared.ingestMarkdown(markdown, title: "MD Doc")
        let entry = await KnowledgeBase.shared.get(id)
        #expect(entry?.category == .documentation)
    }
    
    @Test("Browser search")
    func testBrowserSearch() async {
        _ = await KnowledgeBase.shared.add(title: "Browsable", content: "Browsable content xyz123")
        let results = await KnowledgeBrowser.shared.search("xyz123")
        #expect(!results.isEmpty)
    }
    
    @Test("Favorites")
    func testFavorites() async {
        let id = await KnowledgeBase.shared.add(title: "Favorite Entry", content: "Content")
        await KnowledgeBrowser.shared.addFavorite(id)
        let isFav = await KnowledgeBrowser.shared.isFavorite(id)
        #expect(isFav)
        await KnowledgeBrowser.shared.removeFavorite(id)
        let isNotFav = await KnowledgeBrowser.shared.isFavorite(id)
        #expect(!isNotFav)
    }
    
    @Test("Knowledge stats")
    func testStats() async {
        let stats = await KnowledgeBase.shared.stats
        #expect(stats.totalEntries >= 0)
    }
}
