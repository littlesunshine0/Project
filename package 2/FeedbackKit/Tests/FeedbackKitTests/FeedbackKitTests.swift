import Testing
@testable import FeedbackKit

@Suite("FeedbackKit Tests")
struct FeedbackKitTests {
    
    @Test("Submit feedback")
    func testSubmitFeedback() async {
        let id = await FeedbackCollector.shared.submit(message: "Great feature!", category: .praise, rating: 5)
        let feedback = await FeedbackCollector.shared.getFeedback(id)
        #expect(feedback != nil)
        #expect(feedback?.message == "Great feature!")
        #expect(feedback?.rating == 5)
    }
    
    @Test("Get by category")
    func testGetByCategory() async {
        _ = await FeedbackCollector.shared.submit(message: "Bug report", category: .bug)
        let bugs = await FeedbackCollector.shared.getByCategory(.bug)
        #expect(!bugs.isEmpty)
    }
    
    @Test("Feedback stats")
    func testFeedbackStats() async {
        _ = await FeedbackCollector.shared.submit(message: "Test", rating: 4)
        let stats = await FeedbackCollector.shared.stats
        #expect(stats.totalFeedback >= 1)
    }
    
    @Test("Add suggestion rule")
    func testAddSuggestionRule() async {
        let rule = SuggestionRule(title: "Tip", message: "Try this!", conditions: ["state": "idle"], priority: .high)
        await SuggestionEngine.shared.addRule(rule)
        let rules = await SuggestionEngine.shared.getRules()
        #expect(!rules.isEmpty)
    }
    
    @Test("Get suggestions for context")
    func testGetSuggestions() async {
        let rule = SuggestionRule(title: "Help", message: "Need help?", conditions: ["page": "home"])
        await SuggestionEngine.shared.addRule(rule)
        let suggestions = await SuggestionEngine.shared.getSuggestions(for: ["page": "home"])
        #expect(suggestions.contains { $0.title == "Help" })
    }
    
    @Test("Record command")
    func testRecordCommand() async {
        await CommandSuggestionService.shared.recordCommand("/help")
        await CommandSuggestionService.shared.recordCommand("/help")
        let frequent = await CommandSuggestionService.shared.getFrequentCommands()
        #expect(frequent.contains("/help"))
    }
    
    @Test("Suggest commands")
    func testSuggestCommands() async {
        await CommandSuggestionService.shared.recordCommand("/search")
        let suggestions = await CommandSuggestionService.shared.suggestCommands(for: "/sea")
        #expect(suggestions.contains("/search"))
    }
}
