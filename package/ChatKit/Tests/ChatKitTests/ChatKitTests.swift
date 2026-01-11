import Testing
@testable import ChatKit

@Suite("ChatKit Tests")
struct ChatKitTests {
    
    @Test("Create conversation")
    func testCreateConversation() async {
        let conversation = await ChatEngine.shared.createConversation(title: "Test Chat")
        #expect(conversation.title == "Test Chat")
        #expect(conversation.messages.isEmpty)
    }
    
    @Test("Send message")
    func testSendMessage() async {
        let conversation = await ChatEngine.shared.createConversation()
        let message = await ChatEngine.shared.send("Hello!", to: conversation.id)
        #expect(message != nil)
        #expect(message?.content == "Hello!")
        #expect(message?.role == .user)
    }
    
    @Test("Respond to conversation")
    func testRespond() async {
        let conversation = await ChatEngine.shared.createConversation()
        _ = await ChatEngine.shared.send("Hi", to: conversation.id)
        let response = await ChatEngine.shared.respond(to: conversation.id, content: "Hello! How can I help?")
        #expect(response?.role == .assistant)
    }
    
    @Test("Get conversation")
    func testGetConversation() async {
        let created = await ChatEngine.shared.createConversation(title: "Retrievable")
        let retrieved = await ChatEngine.shared.getConversation(created.id)
        #expect(retrieved != nil)
        #expect(retrieved?.title == "Retrievable")
    }
    
    @Test("Delete conversation")
    func testDeleteConversation() async {
        let conversation = await ChatEngine.shared.createConversation()
        await ChatEngine.shared.deleteConversation(conversation.id)
        let retrieved = await ChatEngine.shared.getConversation(conversation.id)
        #expect(retrieved == nil)
    }
    
    @Test("Help system search")
    func testHelpSearch() async {
        let results = await HelpSystem.shared.search("commands")
        #expect(!results.isEmpty)
    }
    
    @Test("Help topic by category")
    func testHelpByCategory() async {
        let tutorials = await HelpSystem.shared.getByCategory(.tutorial)
        #expect(!tutorials.isEmpty)
    }
    
    @Test("Proactive rules")
    func testProactiveRules() async {
        let rule = ProactiveRule(trigger: "idle", message: "Need help?", conditions: ["state": "idle"])
        await ProactiveMessageService.shared.addRule(rule)
        let messages = await ProactiveMessageService.shared.checkTriggers(context: ["state": "idle"])
        #expect(messages.contains("Need help?"))
    }
    
    @Test("Chat stats")
    func testChatStats() async {
        let stats = await ChatEngine.shared.stats
        #expect(stats.conversationCount >= 0)
    }
}
