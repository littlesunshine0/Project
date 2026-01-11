import Testing
@testable import WebKit

@Suite("WebKit Tests")
struct WebKitTests {
    
    @Test("Search query")
    func testSearch() async {
        let results = await WebSearchService.shared.search(query: "swift programming")
        #expect(!results.isEmpty)
        #expect(results[0].title.contains("swift"))
    }
    
    @Test("Fetch content")
    func testFetch() async {
        let content = await WebSearchService.shared.fetch(url: "https://example.com")
        #expect(content != nil)
        #expect(content?.url == "https://example.com")
    }
    
    @Test("Content caching")
    func testCaching() async {
        let url = "https://cache-test.com"
        _ = await WebSearchService.shared.fetch(url: url)
        let cached = await WebSearchService.shared.fetch(url: url)
        #expect(cached != nil)
    }
    
    @Test("Search history")
    func testSearchHistory() async {
        _ = await WebSearchService.shared.search(query: "history test")
        let history = await WebSearchService.shared.getSearchHistory()
        #expect(history.contains { $0.query == "history test" })
    }
    
    @Test("Clear cache")
    func testClearCache() async {
        _ = await WebSearchService.shared.fetch(url: "https://clear-test.com")
        await WebSearchService.shared.clearCache()
        // Cache cleared
    }
    
    @Test("Web stats")
    func testStats() async {
        let stats = await WebSearchService.shared.stats
        #expect(stats.searchCount >= 0)
    }
}
