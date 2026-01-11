//
//  CommandParserPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for CommandParser
//

import XCTest
import SwiftCheck
@testable import Project

class CommandParserPropertyTests: XCTestCase {
    
    var parser: CommandParser!
    
    override func setUp() {
        super.setUp()
        parser = CommandParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    // MARK: - Property 78: Slash command recognition
    // **Feature: workflow-assistant-app, Property 78: Slash command recognition**
    // **Validates: Requirements 20.1**
    
    func testSlashCommandRecognition() {
        // Property: For any user input starting with a forward slash, the system should recognize it as a command
        
        property("Any input starting with / is recognized as a command") <- forAll { (commandName: String, args: [String]) in
            // Generate a slash command
            let input = "/" + commandName + (args.isEmpty ? "" : " " + args.joined(separator: " "))
            
            // The parser should recognize it as a command
            return self.parser.isCommand(input)
        }.withSize(100)
    }
    
    func testNonSlashInputNotRecognizedAsCommand() {
        // Property: For any input NOT starting with /, it should NOT be recognized as a command
        
        property("Input not starting with / is not recognized as a command") <- forAll { (text: String) in
            // Skip if text starts with /
            guard !text.hasPrefix("/") else { return Discard() }
            
            // The parser should NOT recognize it as a command
            return !self.parser.isCommand(text)
        }.withSize(100)
    }
    
    func testEmptySlashIsRecognizedAsCommand() {
        // Edge case: Just "/" should be recognized as a command (even if invalid)
        XCTAssertTrue(parser.isCommand("/"))
    }
    
    func testSlashWithWhitespaceIsRecognizedAsCommand() {
        // Property: Slash commands with leading/trailing whitespace are still recognized
        
        property("Slash commands with whitespace are recognized") <- forAll { (spaces: String, commandName: String) in
            // Generate whitespace (spaces and tabs)
            let whitespace = String(repeating: " ", count: abs(spaces.count % 10))
            let input = whitespace + "/" + commandName
            
            return self.parser.isCommand(input)
        }.withSize(100)
    }
    
    func testValidCommandTypesParse() {
        // Property: All valid command types should parse successfully
        
        property("Valid command types parse successfully") <- forAll { (commandType: CommandParser.CommandType, args: [String]) in
            let input = "/" + commandType.rawValue + (args.isEmpty ? "" : " " + args.joined(separator: " "))
            
            do {
                let parsed = try self.parser.parse(input)
                return parsed.type == commandType
            } catch {
                return false
            }
        }.withSize(100)
    }
    
    func testInvalidCommandTypesThrowError() {
        // Property: Invalid command names should throw an error
        
        property("Invalid command names throw error") <- forAll { (invalidName: String) in
            // Skip if it's a valid command type
            let validNames = CommandParser.CommandType.allCases.map { $0.rawValue }
            guard !validNames.contains(invalidName.lowercased()) else { return Discard() }
            
            // Skip empty strings
            guard !invalidName.isEmpty else { return Discard() }
            
            let input = "/" + invalidName
            
            do {
                _ = try self.parser.parse(input)
                return false // Should have thrown
            } catch CommandParseError.unknownCommand {
                return true
            } catch {
                return false // Wrong error type
            }
        }.withSize(100)
    }
    
    func testParsedCommandPreservesArguments() {
        // Property: Parsed commands should preserve all arguments
        
        property("Parsed commands preserve arguments") <- forAll { (commandType: CommandParser.CommandType, args: [String]) in
            // Filter out empty arguments
            let nonEmptyArgs = args.filter { !$0.isEmpty }
            
            let input = "/" + commandType.rawValue + (nonEmptyArgs.isEmpty ? "" : " " + nonEmptyArgs.joined(separator: " "))
            
            do {
                let parsed = try self.parser.parse(input)
                return parsed.arguments == nonEmptyArgs
            } catch {
                return false
            }
        }.withSize(100)
    }
}

// MARK: - Arbitrary Instances

extension CommandParser.CommandType: Arbitrary {
    public static var arbitrary: Gen<CommandParser.CommandType> {
        return Gen.fromElements(of: CommandParser.CommandType.allCases)
    }
}
