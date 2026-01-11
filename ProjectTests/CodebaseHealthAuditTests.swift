//
//  CodebaseHealthAuditTests.swift
//  ProjectTests
//
//  Comprehensive audit tests to identify:
//  - Working functionality
//  - Empty/placeholder implementations
//  - Broken/dead code
//  - View-to-service connections
//  - Improvement suggestions
//

import XCTest
@testable import Project

// MARK: - Audit Result Types

struct AuditResult {
    enum Status: String {
        case working = "✅ WORKING"
        case partial = "⚠️ PARTIAL"
        case empty = "📭 EMPTY"
        case broken = "❌ BROKEN"
        case dead = "💀 DEAD"
    }
    
    let component: String
    let status: Status
    let details: String
    let suggestions: [String]
}

// MARK: - Service Audit Tests

class ServiceAuditTests: XCTestCase {
    
    var auditResults: [AuditResult] = []
    
    override func tearDown() {
        // Print audit report at end
        printAuditReport()
        super.tearDown()
    }
    
    // MARK: - Core Services
    
    func testWorkflowOrchestratorAudit() async throws {
        let orchestrator = WorkflowOrchestrator()
        var status: AuditResult.Status = .working
        var details = ""
        var suggestions: [String] = []
        
        // Test 1: Can create workflow execution
        let testWorkflow = Workflow(
            id: UUID(),
            name: "Test Workflow",
            description: "Audit test",
            steps: [
                .command(Command(script: "echo 'test'", description: "Test command", requiresPermission: false, timeout: 10))
            ],
            category: .development,
            tags: ["test"],
            isBuiltIn: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        do {
            let result = try await orchestrator.executeWorkflow(testWorkflow)
            switch result {
            case .success:
                details = "Workflow execution works correctly"
            case .partial:
                status = .partial
                details = "Workflow execution partially works"
            case .failure(let error):
                status = .broken
                details = "Workflow execution failed: \(error.localizedDescription)"
            }
        } catch {
            status = .broken
            details = "Exception during workflow execution: \(error.localizedDescription)"
            suggestions.append("Fix CommandExecutor sandbox permissions")
        }
        
        auditResults.append(AuditResult(
            component: "WorkflowOrchestrator",
            status: status,
            details: details,
            suggestions: suggestions
        ))
    }
    
    func testCommandExecutorAudit() async throws {
        let executor = CommandExecutor()
        var status: AuditResult.Status = .working
        var details = ""
        var suggestions: [String] = []
        
        // Test simple command
        let simpleCommand = Command(
            script: "echo 'Hello World'",
            description: "Simple echo",
            requiresPermission: false,
            timeout: 10
        )
        
        do {
            let result = try await executor.execute(simpleCommand)
            if result.isSuccess {
                details = "Command execution works. Output: \(result.output.prefix(50))"
            } else {
                status = .partial
                details = "Command executed but returned error: \(result.error ?? "unknown")"
            }
        } catch {
            status = .broken
            details = "Command execution failed: \(error.localizedDescription)"
            suggestions.append("Check SandboxManager permissions")
            suggestions.append("Verify /bin/sh is accessible")
        }
        
        auditResults.append(AuditResult(
            component: "CommandExecutor",
            status: status,
            details: details,
            suggestions: suggestions
        ))
    }
    
    func testDatabaseServiceAudit() async throws {
        var status: AuditResult.Status = .working
        var details = ""
        var suggestions: [String] = []
        
        // Test database connection
        let dbService = DatabaseService.shared
        
        // Check if database file exists
        let dbPath = dbService.databasePath
        if FileManager.default.fileExists(atPath: dbPath) {
            details = "Database exists at \(dbPath)"
            
            // Test a simple query
            do {
                let count = try await dbService.getTableCount("knowledge")
                details += ". Knowledge table has \(count) rows"
            } catch {
                status = .partial
                details += ". Query failed: \(error.localizedDescription)"
                suggestions.append("Run database migration")
            }
        } else {
            status = .broken
            details = "Database file not found at \(dbPath)"
            suggestions.append("Initialize database with schema")
            suggestions.append("Run KnowledgeBaseService migration")
        }
        
        auditResults.append(AuditResult(
            component: "DatabaseService",
            status: status,
            details: details,
            suggestions: suggestions
        ))
    }
    
    func testKnowledgeBaseServiceAudit() async throws {
        let service = KnowledgeBaseService.shared
        var status: AuditResult.Status = .working
        var details = ""
        var suggestions: [String] = []
        
        // Test search functionality
        let results = await service.search(query: "swift", limit: 10)
        
        if results.isEmpty {
            status = .empty
            details = "Knowledge base search returns no results"
            suggestions.append("Index content into knowledge base")
            suggestions.append("Run migration script")
        } else {
            details = "Knowledge base has \(results.count) results for 'swift'"
        }
        
        auditResults.append(AuditResult(
            component: "KnowledgeBaseService",
            status: status,
            details: details,
            suggestions: suggestions
        ))
    }
    
    func testMarketplaceIntegrationAudit() async throws {
        let service = await MarketplaceIntegrationService.shared
        var status: AuditResult.Status = .partial
        var details = ""
        var suggestions: [String] = []
        
        // Check connected accounts
        let connectedCount = await service.connectedAccounts.count
        
        if connectedCount > 0 {
            status = .working
            details = "\(connectedCount) marketplace(s) connected"
        } else {
            details = "No marketplaces connected"
            suggestions.append("Configure marketplace credentials")
            suggestions.append("Register flowkit:// URL scheme in eBay Developer Portal")
        }
        
        // Check if credentials manager has stored credentials
        let credManager = await MarketplaceCredentialsManager.shared
        let hasEbayCredentials = await credManager.hasCredentials(for: .ebay)
        
        if hasEbayCredentials {
            details += ". eBay credentials stored"
        } else {
            suggestions.append("Enter eBay API credentials in Settings > Marketplaces")
        }
        
        auditResults.append(AuditResult(
            component: "MarketplaceIntegrationService",
            status: status,
            details: details,
            suggestions: suggestions
        ))
    }
    
    func testNLUEngineAudit() async throws {
        var status: AuditResult.Status = .working
        var details = ""
        var suggestions: [String] = []
        
        // Check if ML models exist
        let modelPath = Bundle.main.path(forResource: "IntentClassifier", ofType: "mlmodelc")
        let embeddingPath = Bundle.main.path(forResource: "SentenceEmbedding", ofType: "mlmodelc")
        
        if modelPath == nil {
            status = .broken
            details = "IntentClassifier model not found"
            suggestions.append("Convert and add IntentClassifier.mlpackage to bundle")
        }
        
        if embeddingPath == nil {
            if status == .broken {
                details += ". SentenceEmbedding model also not found"
            } else {
                status = .partial
                details = "SentenceEmbedding model not found"
            }
            suggestions.append("Convert and add SentenceEmbedding.mlpackage to bundle")
        }
        
        if modelPath != nil && embeddingPath != nil {
            details = "ML models found in bundle"
            
            // Test NLU processing
            let nlu = NLUEngine()
            do {
                let result = try await nlu.process("run tests")
                details += ". Intent: \(result.intent), confidence: \(result.confidence)"
            } catch {
                status = .partial
                details += ". Processing failed: \(error.localizedDescription)"
            }
        }
        
        auditResults.append(AuditResult(
            component: "NLUEngine",
            status: status,
            details: details,
            suggestions: suggestions
        ))
    }
    
    // MARK: - Helper
    
    private func printAuditReport() {
        print("\n" + String(repeating: "=", count: 80))
        print("SERVICE AUDIT REPORT")
        print(String(repeating: "=", count: 80))
        
        for result in auditResults {
            print("\n\(result.status.rawValue) \(result.component)")
            print("   Details: \(result.details)")
            if !result.suggestions.isEmpty {
                print("   Suggestions:")
                for suggestion in result.suggestions {
                    print("   • \(suggestion)")
                }
            }
        }
        
        print("\n" + String(repeating: "=", count: 80))
        
        let working = auditResults.filter { $0.status == .working }.count
        let partial = auditResults.filter { $0.status == .partial }.count
        let broken = auditResults.filter { $0.status == .broken }.count
        let empty = auditResults.filter { $0.status == .empty }.count
        
        print("SUMMARY: \(working) working, \(partial) partial, \(broken) broken, \(empty) empty")
        print(String(repeating: "=", count: 80) + "\n")
    }
}
