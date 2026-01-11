//
//  DataExportServiceTests.swift
//  ProjectTests
//
//  Unit tests for DataExportService
//

import XCTest
@testable import Project

final class DataExportServiceTests: XCTestCase {
    
    var exportService: DataExportService!
    var persistenceController: PersistenceController!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Use in-memory store for testing
        persistenceController = PersistenceController(inMemory: true)
        exportService = DataExportService(persistenceController: persistenceController)
    }
    
    override func tearDown() async throws {
        exportService = nil
        persistenceController = nil
        
        try await super.tearDown()
    }
    
    // MARK: - Workflow Export Tests
    
    func testExportWorkflows() async throws {
        // Given: A workflow is saved
        let workflow = Workflow(
            name: "Test Workflow",
            description: "A test workflow",
            steps: [.command(Command(script: "echo test", description: "Test command"))],
            category: .development,
            tags: ["test"]
        )
        
        try await saveWorkflow(workflow)
        
        // When: Exporting workflows
        let data = try await exportService.exportWorkflows()
        
        // Then: Data should be valid JSON
        XCTAssertFalse(data.isEmpty)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let workflows = try decoder.decode([Workflow].self, from: data)
        
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows.first?.name, "Test Workflow")
    }
    
    func testExportSingleWorkflow() async throws {
        // Given: A workflow is saved
        let workflow = Workflow(
            name: "Single Workflow",
            description: "A single workflow",
            steps: [],
            category: .general
        )
        
        try await saveWorkflow(workflow)
        
        // When: Exporting a single workflow
        let data = try await exportService.exportWorkflow(workflow.id)
        
        // Then: Data should contain the workflow
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let exportedWorkflow = try decoder.decode(Workflow.self, from: data)
        
        XCTAssertEqual(exportedWorkflow.id, workflow.id)
        XCTAssertEqual(exportedWorkflow.name, "Single Workflow")
    }
    
    // MARK: - Backup Tests
    
    func testCreateBackup() async throws {
        // Given: Some data exists
        let workflow = Workflow(
            name: "Backup Test",
            description: "Test backup",
            steps: [],
            category: .testing
        )
        
        try await saveWorkflow(workflow)
        
        // When: Creating a backup
        let data = try await exportService.createBackup()
        
        // Then: Backup should contain all data
        XCTAssertFalse(data.isEmpty)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let exportData = try decoder.decode(DataExportService.ExportData.self, from: data)
        
        XCTAssertEqual(exportData.version, "1.0")
        XCTAssertEqual(exportData.workflows.count, 1)
        XCTAssertEqual(exportData.workflows.first?.name, "Backup Test")
    }
    
    func testRestoreBackup() async throws {
        // Given: A backup with workflow data
        let workflow = Workflow(
            name: "Restore Test",
            description: "Test restore",
            steps: [],
            category: .general
        )
        
        let exportData = DataExportService.ExportData(
            workflows: [workflow],
            history: [],
            metrics: []
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(exportData)
        
        // Create a temporary file
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-backup.json")
        try data.write(to: tempURL)
        
        // When: Restoring the backup
        try await exportService.restoreBackup(from: tempURL, mergeStrategy: .replace)
        
        // Then: Workflow should be restored
        let workflows = try await fetchAllWorkflows()
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows.first?.name, "Restore Test")
        
        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    func testImportWorkflow() async throws {
        // Given: A workflow JSON
        let workflow = Workflow(
            name: "Import Test",
            description: "Test import",
            steps: [],
            category: .documentation
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(workflow)
        
        // When: Importing the workflow
        let importedWorkflow = try await exportService.importWorkflow(from: data)
        
        // Then: Workflow should be imported
        XCTAssertEqual(importedWorkflow.name, "Import Test")
        
        let workflows = try await fetchAllWorkflows()
        XCTAssertEqual(workflows.count, 1)
    }
    
    func testMergeStrategy() async throws {
        // Given: An existing workflow
        let existingWorkflow = Workflow(
            id: UUID(),
            name: "Existing",
            description: "Existing workflow",
            steps: [],
            category: .general
        )
        
        try await saveWorkflow(existingWorkflow)
        
        // And: A backup with a different workflow
        let newWorkflow = Workflow(
            id: UUID(),
            name: "New",
            description: "New workflow",
            steps: [],
            category: .general
        )
        
        let exportData = DataExportService.ExportData(
            workflows: [newWorkflow],
            history: [],
            metrics: []
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(exportData)
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-merge.json")
        try data.write(to: tempURL)
        
        // When: Restoring with merge strategy
        try await exportService.restoreBackup(from: tempURL, mergeStrategy: .merge)
        
        // Then: Both workflows should exist
        let workflows = try await fetchAllWorkflows()
        XCTAssertEqual(workflows.count, 2)
        
        let names = Set(workflows.map { $0.name })
        XCTAssertTrue(names.contains("Existing"))
        XCTAssertTrue(names.contains("New"))
        
        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    func testReplaceStrategy() async throws {
        // Given: An existing workflow
        let existingWorkflow = Workflow(
            name: "Existing",
            description: "Existing workflow",
            steps: [],
            category: .general
        )
        
        try await saveWorkflow(existingWorkflow)
        
        // And: A backup with a different workflow
        let newWorkflow = Workflow(
            name: "New",
            description: "New workflow",
            steps: [],
            category: .general
        )
        
        let exportData = DataExportService.ExportData(
            workflows: [newWorkflow],
            history: [],
            metrics: []
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(exportData)
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-replace.json")
        try data.write(to: tempURL)
        
        // When: Restoring with replace strategy
        try await exportService.restoreBackup(from: tempURL, mergeStrategy: .replace)
        
        // Then: Only the new workflow should exist
        let workflows = try await fetchAllWorkflows()
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows.first?.name, "New")
        
        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    // MARK: - Helper Methods
    
    private func saveWorkflow(_ workflow: Workflow) async throws {
        let context = persistenceController.container.viewContext
        
        try await context.perform {
            let entity = WorkflowEntity(context: context)
            try entity.update(from: workflow)
            try context.save()
        }
    }
    
    private func fetchAllWorkflows() async throws -> [Workflow] {
        let context = persistenceController.container.viewContext
        
        return try await context.perform {
            let request = WorkflowEntity.fetchRequest()
            let entities = try context.fetch(request)
            return try entities.map { try $0.toDomainModel() }
        }
    }
}
