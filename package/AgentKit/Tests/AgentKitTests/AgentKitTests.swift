//
//  AgentKitTests.swift
//  AgentKit
//
//  Tests for AgentKit package
//

import XCTest
@testable import AgentKit

final class AgentKitTests: XCTestCase {
    
    // MARK: - Agent Model Tests
    
    func testAgentCreation() {
        let agent = Agent(
            name: "Test Agent",
            description: "A test agent",
            type: .task
        )
        
        XCTAssertEqual(agent.name, "Test Agent")
        XCTAssertEqual(agent.description, "A test agent")
        XCTAssertEqual(agent.type, .task)
        XCTAssertEqual(agent.status, .idle)
        XCTAssertEqual(agent.runCount, 0)
        XCTAssertEqual(agent.successCount, 0)
    }
    
    func testAgentSuccessRate() {
        var agent = Agent(name: "Test", type: .task)
        
        XCTAssertEqual(agent.successRate, 0)
        
        agent.runCount = 10
        agent.successCount = 8
        
        XCTAssertEqual(agent.successRate, 0.8)
    }
    
    func testAgentEquality() {
        let id = UUID()
        let agent1 = Agent(id: id, name: "Agent 1", type: .task)
        let agent2 = Agent(id: id, name: "Agent 2", type: .monitor)
        
        XCTAssertEqual(agent1, agent2) // Same ID = equal
    }
    
    // MARK: - Agent Type Tests
    
    func testAllAgentTypes() {
        let types = AgentType.allCases
        XCTAssertEqual(types.count, 8)
        
        for type in types {
            XCTAssertFalse(type.icon.isEmpty)
            XCTAssertFalse(type.description.isEmpty)
        }
    }
    
    func testAgentTypeIcons() {
        XCTAssertEqual(AgentType.task.icon, "checklist")
        XCTAssertEqual(AgentType.builder.icon, "hammer")
        XCTAssertEqual(AgentType.watcher.icon, "eye")
    }
    
    // MARK: - Agent Status Tests
    
    func testAllAgentStatuses() {
        let statuses = AgentStatus.allCases
        XCTAssertEqual(statuses.count, 5)
        
        for status in statuses {
            XCTAssertFalse(status.icon.isEmpty)
        }
    }
    
    // MARK: - Agent Capability Tests
    
    func testAllCapabilities() {
        let capabilities = AgentCapability.allCases
        XCTAssertTrue(capabilities.count >= 16)
        XCTAssertTrue(capabilities.contains(.executeCommands))
        XCTAssertTrue(capabilities.contains(.aiCapabilities))
    }
    
    // MARK: - Agent Trigger Tests
    
    func testTriggerCreation() {
        let trigger = AgentTrigger(
            type: .fileChange,
            condition: "*.swift",
            parameters: ["path": "/src"]
        )
        
        XCTAssertEqual(trigger.type, .fileChange)
        XCTAssertEqual(trigger.condition, "*.swift")
        XCTAssertEqual(trigger.parameters["path"], "/src")
        XCTAssertTrue(trigger.isEnabled)
    }
    
    func testAllTriggerTypes() {
        let types = AgentTrigger.TriggerType.allCases
        XCTAssertEqual(types.count, 8)
        XCTAssertTrue(types.contains(.manual))
        XCTAssertTrue(types.contains(.schedule))
        XCTAssertTrue(types.contains(.fileChange))
    }
    
    // MARK: - Agent Action Tests
    
    func testActionCreation() {
        let action = AgentAction(
            name: "Build",
            type: .shellCommand,
            command: "swift build",
            timeout: 120,
            retryCount: 3
        )
        
        XCTAssertEqual(action.name, "Build")
        XCTAssertEqual(action.type, .shellCommand)
        XCTAssertEqual(action.command, "swift build")
        XCTAssertEqual(action.timeout, 120)
        XCTAssertEqual(action.retryCount, 3)
        XCTAssertFalse(action.continueOnError)
    }
    
    func testAllActionTypes() {
        let types = AgentAction.ActionType.allCases
        XCTAssertTrue(types.count >= 15)
        XCTAssertTrue(types.contains(.shellCommand))
        XCTAssertTrue(types.contains(.aiAnalysis))
    }
    
    // MARK: - Agent Configuration Tests
    
    func testDefaultConfiguration() {
        let config = AgentConfiguration()
        
        XCTAssertEqual(config.maxConcurrentRuns, 1)
        XCTAssertEqual(config.defaultTimeout, 300)
        XCTAssertEqual(config.logLevel, .info)
        XCTAssertFalse(config.notifyOnSuccess)
        XCTAssertTrue(config.notifyOnFailure)
    }
    
    func testCustomConfiguration() {
        let config = AgentConfiguration(
            maxConcurrentRuns: 5,
            defaultTimeout: 600,
            logLevel: .debug,
            notifyOnSuccess: true,
            notifyOnFailure: false
        )
        
        XCTAssertEqual(config.maxConcurrentRuns, 5)
        XCTAssertEqual(config.defaultTimeout, 600)
        XCTAssertEqual(config.logLevel, .debug)
        XCTAssertTrue(config.notifyOnSuccess)
        XCTAssertFalse(config.notifyOnFailure)
    }
    
    // MARK: - Agent Schedule Tests
    
    func testScheduleCreation() {
        let schedule = AgentSchedule(
            type: .daily,
            interval: 3600
        )
        
        XCTAssertEqual(schedule.type, .daily)
        XCTAssertEqual(schedule.interval, 3600)
    }
    
    func testAllScheduleTypes() {
        let types = AgentSchedule.ScheduleType.allCases
        XCTAssertEqual(types.count, 6)
        XCTAssertTrue(types.contains(.cron))
        XCTAssertTrue(types.contains(.daily))
    }
    
    // MARK: - Agent Run Result Tests
    
    func testRunResultCreation() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(10)
        
        let result = AgentRunResult(
            agentId: UUID(),
            startTime: startTime,
            endTime: endTime,
            status: .success,
            output: "Build succeeded",
            error: nil,
            actionResults: []
        )
        
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.duration, 10, accuracy: 0.1)
        XCTAssertNil(result.error)
    }
    
    func testActionResultCreation() {
        let result = AgentRunResult.ActionResult(
            actionId: UUID(),
            actionName: "Build",
            success: true,
            output: "OK",
            error: nil,
            duration: 5.0
        )
        
        XCTAssertEqual(result.actionName, "Build")
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.duration, 5.0)
    }
    
    // MARK: - Codable Tests
    
    func testAgentCodable() throws {
        let agent = Agent(
            name: "Test Agent",
            description: "Test",
            type: .automation,
            capabilities: [.executeCommands, .notifications],
            triggers: [AgentTrigger(type: .manual, condition: "test")],
            actions: [AgentAction(name: "Action", type: .shellCommand, command: "echo test")]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(agent)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Agent.self, from: data)
        
        XCTAssertEqual(decoded.name, agent.name)
        XCTAssertEqual(decoded.type, agent.type)
        XCTAssertEqual(decoded.capabilities.count, agent.capabilities.count)
        XCTAssertEqual(decoded.triggers.count, agent.triggers.count)
        XCTAssertEqual(decoded.actions.count, agent.actions.count)
    }
    
    // MARK: - AgentKit API Tests
    
    func testCreateTaskAgent() {
        let action = AgentAction(name: "Test", type: .shellCommand, command: "echo test")
        let agent = AgentKit.createTaskAgent(
            name: "Task Agent",
            description: "A task agent",
            actions: [action]
        )
        
        XCTAssertEqual(agent.name, "Task Agent")
        XCTAssertEqual(agent.type, .task)
        XCTAssertEqual(agent.actions.count, 1)
        XCTAssertTrue(agent.capabilities.contains(.executeCommands))
    }
    
    func testCreateAutomationAgent() {
        let trigger = AgentTrigger(type: .fileChange, condition: "*.swift")
        let action = AgentAction(name: "Build", type: .buildCommand, command: "swift build")
        
        let agent = AgentKit.createAutomationAgent(
            name: "Auto Builder",
            description: "Builds on file change",
            triggers: [trigger],
            actions: [action]
        )
        
        XCTAssertEqual(agent.name, "Auto Builder")
        XCTAssertEqual(agent.type, .automation)
        XCTAssertEqual(agent.triggers.count, 1)
        XCTAssertTrue(agent.capabilities.contains(.notifications))
    }
}
