import Testing
import Foundation
@testable import AppIdeaKit

@Suite("AppIdeaKit Tests")
struct AppIdeaKitTests {
    
    // MARK: - Idea Creation
    
    @Test("Create idea")
    func testCreateIdea() async {
        let idea = await AppIdeaKit.shared.createIdea(
            name: "TestApp",
            description: "A test application",
            category: .developerTool
        )
        #expect(idea.name == "TestApp")
        #expect(idea.category == .developerTool)
        #expect(!idea.suggestedKits.isEmpty)
    }
    
    @Test("Quick create with auto-detection")
    func testQuickCreate() async {
        let idea = await AppIdeaKit.shared.quickCreate(
            name: "CodeAnalyzer",
            description: "An AI-powered code analyzer that finds bugs automatically"
        )
        #expect(idea.name == "CodeAnalyzer")
        #expect(idea.category == .aiFirst || idea.category == .codeAnalysis)
    }
    
    @Test("Idea with features")
    func testIdeaWithFeatures() async {
        var idea = AppIdea(
            name: "FeatureApp",
            description: "App with features",
            category: .productivity
        )
        idea.features = [
            Feature(name: "Feature1", description: "First feature", priority: .critical),
            Feature(name: "Feature2", description: "Second feature", priority: .high)
        ]
        let saved = await AppIdeaKit.shared.updateIdea(idea)
        #expect(saved.features.count == 2)
    }
    
    // MARK: - Idea Store
    
    @Test("Save and retrieve idea")
    func testSaveRetrieve() async {
        let idea = await AppIdeaKit.shared.createIdea(
            name: "RetrieveTest",
            description: "Test retrieval",
            category: .productivity
        )
        let retrieved = await AppIdeaKit.shared.getIdea(idea.id)
        #expect(retrieved?.name == "RetrieveTest")
    }
    
    @Test("Search ideas")
    func testSearch() async {
        _ = await AppIdeaKit.shared.createIdea(
            name: "SearchableApp",
            description: "This app is searchable",
            category: .productivity
        )
        let results = await AppIdeaKit.shared.search(query: "searchable")
        #expect(results.contains { $0.name == "SearchableApp" })
    }
    
    @Test("Filter by category")
    func testFilterByCategory() async {
        _ = await AppIdeaKit.shared.createIdea(
            name: "AIApp",
            description: "AI application",
            category: .aiFirst
        )
        let aiApps = await AppIdeaKit.shared.ideas(category: .aiFirst)
        #expect(aiApps.contains { $0.name == "AIApp" })
    }
    
    // MARK: - Kit Catalog
    
    @Test("Get all kits")
    func testGetAllKits() async {
        let kits = await AppIdeaKit.shared.availableKits()
        #expect(kits.count >= 20)
    }
    
    @Test("Get auto-attach kits")
    func testAutoAttachKits() async {
        let kits = await AppIdeaKit.shared.autoAttachKits()
        #expect(kits.contains { $0.id == "IdeaKit" })
        #expect(kits.contains { $0.id == "DocKit" })
    }
    
    @Test("Suggest kits for idea")
    func testSuggestKits() async {
        let idea = AppIdea(
            name: "DocGenerator",
            description: "Generates documentation automatically",
            category: .documentation
        )
        let suggested = await AppIdeaKit.shared.suggestKits(for: idea)
        #expect(suggested.contains("DocKit"))
    }
    
    // MARK: - Analysis
    
    @Test("Analyze idea")
    func testAnalyzeIdea() async {
        let idea = AppIdea(
            name: "WorkflowEngine",
            description: "An automation workflow engine with AI capabilities",
            category: .automation
        )
        let analysis = await IdeaAnalyzer.shared.analyze(idea)
        #expect(!analysis.keywords.isEmpty)
        #expect(!analysis.suggestedKits.isEmpty)
        #expect(analysis.confidenceScore > 0)
    }
    
    @Test("Enrich idea with ML")
    func testEnrichIdea() async {
        let idea = AppIdea(
            name: "MLApp",
            description: "Machine learning application",
            category: .mlPowered
        )
        let enriched = await IdeaAnalyzer.shared.enrichIdea(idea)
        #expect(!enriched.mlMetadata.keywords.isEmpty)
        #expect(!enriched.mlMetadata.topics.isEmpty)
    }
    
    // MARK: - Generation
    
    @Test("Generate app from idea")
    func testGenerateApp() async {
        let idea = AppIdea(
            name: "GeneratedApp",
            description: "An app to be generated",
            category: .productivity,
            kind: .package,
            type: .utility
        )
        let result = await AppIdeaKit.shared.generateApp(from: idea)
        #expect(result.structure.name == "GeneratedApp")
        #expect(!result.files.isEmpty)
        #expect(!result.requiredKits.isEmpty)
    }
    
    @Test("Generated files include Package.swift")
    func testGeneratedFiles() async {
        let idea = AppIdea(
            name: "FileTestApp",
            description: "Test file generation",
            category: .developerTool
        )
        let result = await AppGenerator.shared.generate(from: idea)
        #expect(result.files.contains { $0.path == "Package.swift" })
        #expect(result.files.contains { $0.path == "README.md" })
    }
    
    // MARK: - Built-In Ideas
    
    @Test("Built-in ideas exist")
    func testBuiltInIdeas() async {
        let ideas = await BuiltInIdeas.shared.allIdeas
        #expect(ideas.count >= 80) // 86 total ideas
    }
    
    @Test("ML reasoning apps exist")
    func testMLReasoningApps() async {
        let mlApps = await BuiltInIdeas.shared.mlReasoningApps
        #expect(mlApps.contains { $0.name == "IdeaUnderstandingEngine" })
        #expect(mlApps.contains { $0.name == "AssumptionDetector" })
    }
    
    @Test("Reusable ML packages exist")
    func testReusableMLPackages() async {
        let packages = await BuiltInIdeas.shared.reusableMLPackages
        #expect(packages.contains { $0.name == "TextUnderstandingCore" })
        #expect(packages.contains { $0.name == "SemanticSimilarityEngine" })
    }
    
    @Test("Higher-order reasoning apps exist")
    func testHigherOrderReasoning() async {
        let apps = await BuiltInIdeas.shared.higherOrderReasoningApps
        #expect(apps.contains { $0.name == "UncertaintyAwarePlanner" })
        #expect(apps.contains { $0.name == "ContradictionDetectionEngine" })
    }
    
    @Test("Composable ML bricks exist")
    func testComposableMLBricks() async {
        let bricks = await BuiltInIdeas.shared.composableMLBricks
        #expect(bricks.contains { $0.name == "UncertaintyEngine" })
        #expect(bricks.contains { $0.name == "MemoryRetrievalCore" })
    }
    
    @Test("Total ideas count")
    func testTotalIdeasCount() async {
        let ideas = await BuiltInIdeas.shared.allIdeas
        #expect(ideas.count >= 80) // 86 total ideas
    }
    
    @Test("Developer tools category")
    func testDeveloperTools() async {
        let tools = await BuiltInIdeas.shared.developerTools
        #expect(tools.contains { $0.name == "ProjectBootstrapper" })
        #expect(tools.contains { $0.name == "CodebaseMemory" })
    }
    
    @Test("AI-first apps category")
    func testAIFirstApps() async {
        let apps = await BuiltInIdeas.shared.aiFirstApps
        #expect(apps.contains { $0.name == "IdeaToMVP" })
        #expect(apps.contains { $0.name == "TechCoFounder" })
    }
    
    // MARK: - Statistics
    
    @Test("Get statistics")
    func testStats() async {
        let stats = await AppIdeaKit.shared.stats()
        #expect(stats.totalIdeas >= 0)
    }
}
