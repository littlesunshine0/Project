//
//  LearnKitTests.swift
//  LearnKit
//

import XCTest
@testable import LearnKit

final class LearnKitTests: XCTestCase {
    
    func testRecordAction() async {
        let action = UserAction(userId: "user1", actionType: .executeWorkflow, target: "build")
        await LearnKit.record(action)
        
        let stats = await LearningEngine.shared.getStats()
        XCTAssertGreaterThan(stats.actionCount, 0)
    }
    
    func testPrediction() async {
        // Record some actions
        for _ in 0..<5 {
            await LearnKit.record(UserAction(userId: "user1", actionType: .executeWorkflow, target: "build"))
        }
        
        let context = PredictionContext(userId: "user1")
        let predictions = await LearnKit.predict(context: context)
        
        XCTAssertFalse(predictions.isEmpty)
    }
    
    func testSequencePrediction() async {
        // Create a pattern: openFile -> editFile -> saveFile
        await LearnKit.record(UserAction(userId: "user2", actionType: .openFile, target: "test.swift"))
        await LearnKit.record(UserAction(userId: "user2", actionType: .editFile, target: "test.swift"))
        await LearnKit.record(UserAction(userId: "user2", actionType: .saveFile, target: "test.swift"))
        
        // Repeat pattern
        await LearnKit.record(UserAction(userId: "user2", actionType: .openFile, target: "test.swift"))
        await LearnKit.record(UserAction(userId: "user2", actionType: .editFile, target: "test.swift"))
        await LearnKit.record(UserAction(userId: "user2", actionType: .saveFile, target: "test.swift"))
        
        let context = PredictionContext(userId: "user2", recentActions: [.openFile, .editFile])
        let predictions = await LearnKit.predict(context: context)
        
        // Should predict saveFile based on pattern
        XCTAssertTrue(predictions.contains { $0.actionType == .saveFile })
    }
    
    func testSuggestions() async {
        await LearnKit.record(UserAction(userId: "user3", actionType: .searchDocs, target: "SwiftUI"))
        await LearnKit.record(UserAction(userId: "user3", actionType: .searchDocs, target: "Combine"))
        
        let suggestions = await LearnKit.suggest(for: "user3", limit: 3)
        
        XCTAssertFalse(suggestions.isEmpty)
        XCTAssertTrue(suggestions.allSatisfy { $0.score > 0 })
    }
    
    func testTraining() async {
        let actions = [
            UserAction(userId: "train1", actionType: .runCommand, target: "build"),
            UserAction(userId: "train1", actionType: .runCommand, target: "test"),
            UserAction(userId: "train1", actionType: .runCommand, target: "deploy")
        ]
        let trainingData = TrainingData(actions: actions)
        
        await LearnKit.train(with: [trainingData])
        
        let stats = await LearningEngine.shared.getStats()
        XCTAssertGreaterThan(stats.actionCount, 0)
    }
    
    func testUserAction() {
        let action = UserAction(userId: "test", actionType: .createWorkflow, target: "new-workflow", context: ["source": "ui"])
        
        XCTAssertEqual(action.userId, "test")
        XCTAssertEqual(action.actionType, .createWorkflow)
        XCTAssertEqual(action.target, "new-workflow")
        XCTAssertEqual(action.context["source"], "ui")
    }
    
    func testPredictionContext() {
        let context = PredictionContext(userId: "user", currentFile: "test.swift", recentActions: [.openFile, .editFile])
        
        XCTAssertEqual(context.userId, "user")
        XCTAssertEqual(context.currentFile, "test.swift")
        XCTAssertEqual(context.recentActions.count, 2)
    }
    
    func testAllActionTypes() {
        let types = UserAction.ActionType.allCases
        XCTAssertTrue(types.count >= 8)
    }
    
    func testActionCodable() throws {
        let action = UserAction(userId: "test", actionType: .executeWorkflow, target: "build")
        
        let data = try JSONEncoder().encode(action)
        let decoded = try JSONDecoder().decode(UserAction.self, from: data)
        
        XCTAssertEqual(decoded.userId, action.userId)
        XCTAssertEqual(decoded.actionType, action.actionType)
        XCTAssertEqual(decoded.target, action.target)
    }
}
