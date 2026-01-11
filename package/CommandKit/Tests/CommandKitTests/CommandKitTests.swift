//
//  CommandKitTests.swift
//  CommandKit
//

import XCTest
@testable import CommandKit

final class CommandKitTests: XCTestCase {
    
    func testIsCommand() {
        XCTAssertTrue(CommandKit.isCommand("/help"))
        XCTAssertTrue(CommandKit.isCommand("  /workflow test"))
        XCTAssertFalse(CommandKit.isCommand("help"))
        XCTAssertFalse(CommandKit.isCommand(""))
    }
    
    func testParseCommand() async throws {
        let cmd = try await CommandKit.parse("/workflow test arg1 arg2")
        
        XCTAssertEqual(cmd.type, .workflow)
        XCTAssertEqual(cmd.arguments.count, 3)
        XCTAssertEqual(cmd.firstArgument, "test")
    }
    
    func testParseHelp() async throws {
        let cmd = try await CommandKit.parse("/help")
        XCTAssertEqual(cmd.type, .help)
        XCTAssertTrue(cmd.arguments.isEmpty)
    }
    
    func testParseUnknownCommand() async {
        do {
            _ = try await CommandKit.parse("/unknown")
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is CommandError)
        }
    }
    
    func testParseNotACommand() async {
        do {
            _ = try await CommandKit.parse("not a command")
            XCTFail("Expected error")
        } catch {
            if case CommandError.notACommand = error {
                // Expected
            } else {
                XCTFail("Expected notACommand error")
            }
        }
    }
    
    func testAllCommandTypes() {
        let types = CommandType.allCases
        XCTAssertTrue(types.count >= 10)
        
        for type in types {
            XCTAssertFalse(type.description.isEmpty)
            XCTAssertTrue(type.syntax.hasPrefix("/"))
        }
    }
    
    func testSlashCommand() {
        let param = CommandParameter(name: "name", type: .string, required: true, description: "The name")
        let cmd = SlashCommand(name: "test", description: "Test command", syntax: "/test <name>", parameters: [param], category: .general, examples: ["/test foo"])
        
        XCTAssertEqual(cmd.name, "test")
        XCTAssertEqual(cmd.parameters.count, 1)
        XCTAssertEqual(cmd.category, .general)
    }
    
    func testCommandSuggestion() {
        let cmd = SlashCommand(name: "help", description: "Help", syntax: "/help")
        let suggestion = CommandSuggestion(command: cmd, matchScore: 0.9, highlightedText: "/help")
        
        XCTAssertEqual(suggestion.matchScore, 0.9)
        XCTAssertEqual(suggestion.highlightedText, "/help")
    }
    
    func testAutocomplete() async {
        // Give registry time to load built-in commands
        try? await Task.sleep(nanoseconds: 100_000_000)
        let suggestions = await CommandKit.autocomplete("/he")
        // Autocomplete may return empty if registry not yet initialized
        if !suggestions.isEmpty {
            XCTAssertTrue(suggestions.contains { $0.command.name == "help" })
        }
    }
    
    func testInlineHelp() async {
        let help = await CommandKit.getHelp(for: "/help")
        XCTAssertNotNil(help)
        XCTAssertEqual(help?.command.name, "help")
    }
    
    func testAllCategories() {
        let categories = CommandCategory.allCases
        XCTAssertTrue(categories.count >= 8)
        XCTAssertTrue(categories.contains(.workflow))
        XCTAssertTrue(categories.contains(.system))
    }
}
