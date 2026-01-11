//
//  IdeaKitTests.swift
//  IdeaKit Tests
//

import XCTest
@testable import IdeaKit

final class IdeaKitTests: XCTestCase {
    
    override func setUp() async throws {
        // Clear artifact graph before each test
        await ArtifactGraph.shared.clear()
    }
    
    // MARK: - Artifact Tests
    
    func testIntentArtifactCreation() {
        let intent = IntentArtifact(
            problemStatement: "Users need a better way to manage tasks",
            targetUser: "Developers",
            valueProposition: "Simplify task management",
            projectType: .app
        )
        
        XCTAssertEqual(IntentArtifact.artifactType, "intent")
        XCTAssertTrue(intent.artifactId.hasPrefix("intent_"))
        XCTAssertEqual(intent.projectType, .app)
    }
    
    func testArtifactMarkdownGeneration() {
        let intent = IntentArtifact(
            problemStatement: "Test problem",
            targetUser: "Test users",
            valueProposition: "Test value",
            projectType: .cli,
            successCriteria: ["Criterion 1", "Criterion 2"]
        )
        
        let markdown = intent.toMarkdown()
        
        // Verify markdown contains expected content
        XCTAssertFalse(markdown.isEmpty)
        XCTAssertTrue(markdown.contains("Test problem"), "Should contain problem statement")
        XCTAssertTrue(markdown.contains("Test users"), "Should contain target user")
    }
    
    // MARK: - Artifact Graph Tests
    
    func testArtifactGraphRegistration() async {
        let intent = IntentArtifact(problemStatement: "Test")
        
        await ArtifactGraph.shared.register(intent, producedBy: "test")
        
        let retrieved: IntentArtifact? = await ArtifactGraph.shared.get(ofType: IntentArtifact.self)
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.problemStatement, "Test")
    }

    func testArtifactGraphDependencies() async {
        let intent = IntentArtifact(problemStatement: "Test")
        let requirements = RequirementsArtifact()
        
        await ArtifactGraph.shared.register(intent, producedBy: "intent")
        await ArtifactGraph.shared.register(requirements, producedBy: "spec")
        await ArtifactGraph.shared.declareDependency(from: requirements.artifactId, to: intent.artifactId)
        
        let deps = await ArtifactGraph.shared.getDependencies(for: requirements.artifactId)
        XCTAssertTrue(deps.contains(intent.artifactId))
    }
    
    // MARK: - Package Tests
    
    func testIntentPackageIdentity() {
        XCTAssertEqual(IntentPackage.packageId, "intent")
        XCTAssertTrue(IntentPackage.isKernel)
        XCTAssertTrue(IntentPackage.produces.contains("IntentArtifact"))
    }
    
    func testSpecPackageIdentity() {
        XCTAssertEqual(SpecPackage.packageId, "spec")
        XCTAssertTrue(SpecPackage.isKernel)
        XCTAssertTrue(SpecPackage.consumes.contains("IntentArtifact"))
    }
    
    func testPackageManifestCreation() {
        let manifest = PackageManifest(from: IntentPackage.self)
        
        XCTAssertEqual(manifest.id, "intent")
        XCTAssertEqual(manifest.name, "Intent Package")
        XCTAssertTrue(manifest.isKernel)
    }
    
    // MARK: - Integration Tests
    
    func testIntentPackageExecution() async throws {
        let context = ProjectContext(name: "TestProject", path: FileManager.default.temporaryDirectory)
        try context.setupDirectories()
        context.setMetadata("A todo app for developers to track tasks", for: "idea")
        
        let package = IntentPackage()
        try await package.execute(graph: ArtifactGraph.shared, context: context)
        
        let intent: IntentArtifact? = await ArtifactGraph.shared.get(ofType: IntentArtifact.self)
        XCTAssertNotNil(intent)
        XCTAssertEqual(intent?.projectType, .app)
        
        let assumptions: AssumptionArtifact? = await ArtifactGraph.shared.get(ofType: AssumptionArtifact.self)
        XCTAssertNotNil(assumptions)
        XCTAssertFalse(assumptions?.assumptions.isEmpty ?? true)
    }
    
    // MARK: - IdeaKit API Tests
    
    func testIdeaKitVersion() {
        XCTAssertEqual(IdeaKit.version, "2.0.0")
    }
    
    func testKernelPackagesCount() {
        XCTAssertEqual(IdeaKit.kernelPackages.count, 6)
    }
    
    func testPackageManifestsGeneration() {
        let manifests = IdeaKit.packageManifests
        
        XCTAssertEqual(manifests.count, 6)
        XCTAssertTrue(manifests.allSatisfy { $0.isKernel })
    }
}


// MARK: - Universal Capability Tests

extension IdeaKitTests {
    
    func testUniversalCapabilitiesCount() {
        XCTAssertEqual(UniversalCapabilities.all.count, 8, "Should have exactly 8 universal capabilities")
    }
    
    func testUniversalCapabilityIds() {
        let expectedIds = ["intent", "context", "structure", "work", "decisions", "risk", "feedback", "outcome"]
        let actualIds = UniversalCapabilities.all.map { type(of: $0).capabilityId }
        
        for id in expectedIds {
            XCTAssertTrue(actualIds.contains(id), "Should contain capability: \(id)")
        }
    }
    
    func testIntentCapabilityExecution() async throws {
        let context = ProjectContext(name: "TestProject", path: FileManager.default.temporaryDirectory)
        try context.setupDirectories()
        context.setMetadata("A mobile app for tracking fitness goals", for: "idea")
        
        let capability = IntentCapability()
        try await capability.execute(graph: ArtifactGraph.shared, context: context)
        
        let intent: IntentArtifact? = await ArtifactGraph.shared.get(ofType: IntentArtifact.self)
        XCTAssertNotNil(intent)
        XCTAssertEqual(intent?.projectType, .app)
    }
    
    func testContextCapabilityExecution() async throws {
        let context = ProjectContext(name: "TestProject", path: FileManager.default.temporaryDirectory)
        try context.setupDirectories()
        context.setMetadata("A library for data processing", for: "idea")
        
        // First execute intent capability (context depends on it)
        let intentCap = IntentCapability()
        try await intentCap.execute(graph: ArtifactGraph.shared, context: context)
        
        // Then execute context capability
        let contextCap = ContextCapability()
        try await contextCap.execute(graph: ArtifactGraph.shared, context: context)
        
        let contextArtifact: ContextArtifact? = await ArtifactGraph.shared.get(ofType: ContextArtifact.self)
        XCTAssertNotNil(contextArtifact)
        XCTAssertFalse(contextArtifact?.constraints.isEmpty ?? true)
    }
    
    func testCapabilityLookup() {
        let intent = UniversalCapabilities.capability(for: "intent")
        XCTAssertNotNil(intent)
        XCTAssertEqual(type(of: intent!).capabilityId, "intent")
        
        let unknown = UniversalCapabilities.capability(for: "unknown")
        XCTAssertNil(unknown)
    }
    
    func testCapabilityArtifacts() {
        XCTAssertEqual(IntentCapability.artifacts, ["purpose.md", "success_criteria.md", "non_goals.md"])
        XCTAssertEqual(ContextCapability.artifacts, ["constraints.md", "assumptions.md", "dependencies.md"])
        XCTAssertEqual(StructureCapability.artifacts, ["architecture.md", "modules.md", "boundaries.md"])
        XCTAssertEqual(WorkCapability.artifacts, ["tasks.md", "milestones.md", "roadmap.json"])
        XCTAssertEqual(DecisionCapability.artifacts, ["decisions.md", "tradeoffs.md"])
        XCTAssertEqual(RiskCapability.artifacts, ["risks.md", "mitigations.md"])
        XCTAssertEqual(FeedbackCapability.artifacts, ["feedback.md", "lessons_learned.md"])
        XCTAssertEqual(OutcomeCapability.artifacts, ["acceptance_criteria.md", "validation.md"])
    }
    
    func testCapabilityCoreQuestions() {
        XCTAssertEqual(IntentCapability.coreQuestion, "Why does this project exist?")
        XCTAssertEqual(ContextCapability.coreQuestion, "What are the constraints and environment?")
        XCTAssertEqual(StructureCapability.coreQuestion, "How is the project organized?")
        XCTAssertEqual(WorkCapability.coreQuestion, "What tasks must be done?")
        XCTAssertEqual(DecisionCapability.coreQuestion, "Why were these choices made?")
        XCTAssertEqual(RiskCapability.coreQuestion, "What could go wrong?")
        XCTAssertEqual(FeedbackCapability.coreQuestion, "How do we learn and improve?")
        XCTAssertEqual(OutcomeCapability.coreQuestion, "What does success look like?")
    }
}
