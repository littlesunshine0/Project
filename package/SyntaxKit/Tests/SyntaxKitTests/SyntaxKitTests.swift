import Testing
@testable import SyntaxKit

@Suite("SyntaxKit Tests")
struct SyntaxKitTests {
    
    @Test("Get language")
    func testGetLanguage() async {
        let swift = await SyntaxHighlighter.shared.getLanguage("swift")
        #expect(swift != nil)
        #expect(swift?.name == "Swift")
    }
    
    @Test("Detect language by extension")
    func testDetectLanguage() async {
        let detected = await SyntaxHighlighter.shared.detectLanguage(filename: "main.swift")
        #expect(detected?.id == "swift")
    }
    
    @Test("Tokenize code")
    func testTokenize() async {
        let tokens = await SyntaxHighlighter.shared.tokenize("func test", language: "swift")
        #expect(!tokens.isEmpty)
        #expect(tokens.first?.type == .keyword)
    }
    
    @Test("Highlight code")
    func testHighlight() async {
        let lines = await SyntaxHighlighter.shared.highlight("let x = 1\nvar y = 2", language: "swift")
        #expect(lines.count == 2)
        #expect(lines[0].lineNumber == 1)
    }
    
    @Test("Register custom language")
    func testRegisterLanguage() async {
        let custom = Language(id: "custom", name: "Custom", extensions: [".cust"], keywords: ["begin", "end"])
        await SyntaxHighlighter.shared.registerLanguage(custom)
        let retrieved = await SyntaxHighlighter.shared.getLanguage("custom")
        #expect(retrieved?.name == "Custom")
    }
    
    @Test("Supported languages")
    func testSupportedLanguages() async {
        let languages = await SyntaxHighlighter.shared.supportedLanguages
        #expect(languages.count >= 3)
    }
    
    @Test("Syntax stats")
    func testStats() async {
        let stats = await SyntaxHighlighter.shared.stats
        #expect(stats.languageCount >= 3)
    }
}
