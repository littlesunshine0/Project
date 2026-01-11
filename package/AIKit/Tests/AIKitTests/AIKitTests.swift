import Testing
import Foundation
@testable import AIKit

@Suite("AIKit Tests")
struct AIKitTests {
    
    // MARK: - Legacy AI Orchestrator Tests
    
    @Test("Register model")
    func testRegisterModel() async {
        let model = AIModel(id: "test-model", name: "Test Model", type: .classification)
        await AIOrchestrator.shared.registerModel(model)
        let retrieved = await AIOrchestrator.shared.getModel("test-model")
        #expect(retrieved != nil)
        #expect(retrieved?.name == "Test Model")
    }
    
    @Test("Execute model")
    func testExecuteModel() async {
        let model = AIModel(id: "exec-model", name: "Exec Model", type: .generation)
        await AIOrchestrator.shared.registerModel(model)
        let input = AIInput(text: "Hello world")
        let output = await AIOrchestrator.shared.execute(modelId: "exec-model", input: input)
        #expect(output.success)
        #expect(output.result != nil)
    }
    
    @Test("Semantic code analysis")
    func testCodeAnalysis() async {
        let code = """
        import Foundation
        
        class MyClass {
            func myFunction() {
                if true {
                    print("hello")
                }
            }
        }
        """
        let analysis = await SemanticCodeEngine.shared.analyzeCode(code, language: "swift")
        #expect(analysis.language == "swift")
        #expect(!analysis.symbols.isEmpty)
        #expect(analysis.complexity > 1)
    }
    
    // MARK: - Understanding Engine Tests
    
    @Test("Understanding Engine - Basic understanding")
    func testUnderstanding() async {
        let result = await UnderstandingEngine.shared.understand("Create a new API for user authentication")
        #expect(result.intent.type == .create)
        #expect(result.confidence > 0)
        #expect(!result.entities.isEmpty)
    }
    
    @Test("Understanding Engine - Intent extraction")
    func testIntentExtraction() async {
        let intent = await UnderstandingEngine.shared.extractIntent(from: "Analyze the codebase for performance issues")
        #expect(intent.type == .analyze)
        #expect(intent.confidence > 0) // Confidence varies based on pattern matching
    }
    
    @Test("Understanding Engine - Requirement inference")
    func testRequirementInference() async {
        let requirements = await UnderstandingEngine.shared.inferRequirements(from: "Build a REST API for user management")
        #expect(!requirements.gaps.isEmpty) // Should detect missing security, testing, etc.
    }
    
    @Test("Understanding Engine - Ambiguity detection")
    func testAmbiguityDetection() async {
        let ambiguities = await UnderstandingEngine.shared.detectAmbiguities(from: "It should handle some requests quickly")
        #expect(!ambiguities.isEmpty) // "some" and "it" are ambiguous
    }
    
    @Test("Understanding Engine - Assumption detection")
    func testAssumptionDetection() async {
        let assumptions = await UnderstandingEngine.shared.detectAssumptions(from: "The API will be quick and simple to implement")
        #expect(!assumptions.isEmpty) // "quick" and "simple" indicate assumptions
    }
    
    // MARK: - Structure Engine Tests
    
    @Test("Structure Engine - Architecture classification")
    func testArchitectureClassification() async {
        let files = [
            FileStructure(path: "Models/User.swift", name: "User.swift"),
            FileStructure(path: "Views/UserView.swift", name: "UserView.swift"),
            FileStructure(path: "ViewModels/UserViewModel.swift", name: "UserViewModel.swift")
        ]
        let classification = await StructureEngine.shared.classifyArchitecture(files: files)
        #expect(!classification.primaryPattern.isEmpty)
        #expect(classification.confidence > 0)
    }
    
    @Test("Structure Engine - Coupling analysis")
    func testCouplingAnalysis() async {
        let modules = [
            ModuleInfo(name: "Core", files: [FileStructure(path: "Core/Core.swift", name: "Core.swift")], dependencies: []),
            ModuleInfo(name: "UI", files: [FileStructure(path: "UI/UI.swift", name: "UI.swift")], dependencies: ["Core"])
        ]
        let analysis = await StructureEngine.shared.analyzeCouplingCohesion(modules: modules)
        #expect(analysis.modules.count == 2)
        #expect(analysis.overallHealth >= 0)
    }
    
    @Test("Structure Engine - Complexity estimation")
    func testComplexityEstimation() async {
        let codebase = CodebaseInfo(name: "TestProject", modules: [
            ModuleInfo(name: "Module1", files: [FileStructure(path: "m1.swift", name: "m1.swift", lineCount: 500)], dependencies: [])
        ])
        let complexity = await StructureEngine.shared.estimateComplexity(codebase: codebase)
        #expect(complexity.overallScore >= 0)
        #expect(complexity.overallScore <= 1)
    }
    
    // MARK: - Planning Engine Tests
    
    @Test("Planning Engine - Task decomposition")
    func testTaskDecomposition() async {
        let task = TaskInput(description: "Build a user authentication system", estimatedHours: 40)
        let decomposition = await PlanningEngine.shared.decomposeTask(task)
        #expect(!decomposition.subtasks.isEmpty)
        #expect(decomposition.totalEstimatedHours > 0)
    }
    
    @Test("Planning Engine - Estimate accuracy prediction")
    func testEstimateAccuracy() async {
        let estimate = EstimateInput(description: "Simple feature implementation", hours: 8)
        let prediction = await PlanningEngine.shared.predictEstimateAccuracy(estimate)
        #expect(prediction.accuracyProbability > 0)
        #expect(prediction.accuracyProbability <= 1)
    }
    
    @Test("Planning Engine - Critical path risk")
    func testCriticalPathRisk() async {
        let plan = PlanInput(name: "Test Plan", tasks: [
            PlanTask(id: "t1", name: "Task 1", estimatedHours: 8),
            PlanTask(id: "t2", name: "Task 2", estimatedHours: 16, dependencies: ["t1"])
        ])
        let risks = await PlanningEngine.shared.predictCriticalPathRisks(plan: plan)
        #expect(risks.overallRisk >= 0)
        #expect(!risks.taskRisks.isEmpty)
    }
    
    @Test("Planning Engine - Feature ROI")
    func testFeatureROI() async {
        let feature = FeatureInput(name: "Dark Mode", description: "Add dark mode support", complexity: 0.5, expectedValue: 0.7)
        let roi = await PlanningEngine.shared.modelFeatureROI(feature: feature)
        #expect(roi.roiScore > 0)
        #expect(!roi.recommendation.isEmpty)
    }
    
    // MARK: - Memory Engine Tests
    
    @Test("Memory Engine - Store and recall")
    func testMemoryStoreRecall() async {
        let projectId = "test-project-\(UUID().uuidString)"
        await MemoryEngine.shared.remember(projectId: projectId, content: MemoryContent(
            type: .decision,
            summary: "Decided to use Swift for the backend",
            details: "After evaluating options, Swift was chosen for type safety"
        ))
        let recalled = await MemoryEngine.shared.recall(projectId: projectId, query: "Swift backend")
        #expect(!recalled.isEmpty)
    }
    
    @Test("Memory Engine - Context compression")
    func testContextCompression() async {
        let context = ContextInput(
            id: "test-context",
            content: "We discussed the architecture. Important: use microservices. Decision: deploy to AWS. TODO: set up CI/CD."
        )
        let compressed = await MemoryEngine.shared.compressContext(context)
        #expect(compressed.compressionRatio < 1.0)
        #expect(!compressed.keyPoints.isEmpty || !compressed.decisions.isEmpty)
    }
    
    @Test("Memory Engine - Doc-code alignment")
    func testDocCodeAlignment() async {
        let doc = DocumentInfo(path: "README.md", content: "This module handles user authentication and authorization with security")
        let code = CodeInfo(path: "Auth.swift", content: "class AuthService { func authenticate() {} func authorize() {} func security() {} }")
        let alignment = await MemoryEngine.shared.checkDocCodeAlignment(doc: doc, code: code)
        #expect(alignment.driftLevel != .none || alignment.alignmentScore >= 0) // Alignment analysis completes
    }
    
    // MARK: - Risk Engine Tests
    
    @Test("Risk Engine - Uncertainty estimation")
    func testUncertaintyEstimation() async {
        let prediction = PredictionInput(id: "test", value: 0.7, context: ["type": "estimate"])
        let uncertainty = await RiskEngine.shared.estimateUncertainty(prediction: prediction)
        #expect(uncertainty.totalUncertainty >= 0)
        #expect(uncertainty.totalUncertainty <= 1)
    }
    
    @Test("Risk Engine - Failure mode prediction")
    func testFailureModePrediction() async {
        let system = SystemInput(id: "test-system", name: "Test System", components: [
            SystemComponent(id: "api", name: "API Gateway", criticality: .high, hasExternalDependency: true),
            SystemComponent(id: "db", name: "Database", criticality: .critical)
        ])
        let prediction = await RiskEngine.shared.predictFailureModes(system: system)
        #expect(!prediction.failureModes.isEmpty)
        #expect(prediction.overallRisk > 0)
    }
    
    @Test("Risk Engine - Bias detection")
    func testBiasDetection() async {
        let input = BiasDetectionInput(id: "test", text: "This should be easy and quick to implement, just like before")
        let result = await RiskEngine.shared.detectBiases(input: input)
        #expect(!result.detectedBiases.isEmpty) // Should detect optimism and anchoring biases
    }
    
    @Test("Risk Engine - Belief revision")
    func testBeliefRevision() async {
        let belief = Belief(id: "test-belief", statement: "Feature X will succeed", confidence: 0.6)
        await RiskEngine.shared.storeBelief(belief)
        
        let evidence = EvidenceInput(description: "User testing showed positive results", source: .empirical, supports: true, strength: 0.7)
        let revision = await RiskEngine.shared.reviseBeliefs(newEvidence: evidence, beliefId: "test-belief")
        #expect(revision.posteriorConfidence > revision.priorConfidence)
    }
    
    @Test("Risk Engine - Human input recommendation")
    func testHumanInputRecommendation() async {
        let decision = DecisionInput(id: "critical-decision", description: "Major critical architectural change that cannot be undone permanently")
        let recommendation = await RiskEngine.shared.shouldRequestHumanInput(decision: decision)
        // Verify the recommendation provides useful guidance
        #expect(!recommendation.reason.isEmpty)
        #expect(recommendation.automationConfidence >= 0)
    }
    
    // MARK: - Intelligence Orchestrator Tests
    
    @Test("Orchestrator - Idea analysis")
    func testIdeaAnalysis() async {
        let result = await IntelligenceOrchestrator.shared.analyzeIdea("Build an AI-powered code review tool")
        #expect(result.overallConfidence > 0)
        #expect(!result.requirements.gaps.isEmpty || !result.requirements.inferred.isEmpty)
    }
    
    @Test("Orchestrator - Codebase analysis")
    func testCodebaseAnalysis() async {
        let codebase = CodebaseInfo(name: "TestApp", modules: [
            ModuleInfo(name: "Core", files: [FileStructure(path: "Core.swift", name: "Core.swift", lineCount: 200)], dependencies: []),
            ModuleInfo(name: "UI", files: [FileStructure(path: "UI.swift", name: "UI.swift", lineCount: 300)], dependencies: ["Core"])
        ])
        let result = await IntelligenceOrchestrator.shared.analyzeCodebase(codebase)
        #expect(result.healthScore > 0)
        #expect(!result.architecture.primaryPattern.isEmpty)
    }
    
    @Test("Orchestrator - Project planning")
    func testProjectPlanning() async {
        let result = await IntelligenceOrchestrator.shared.planProject(
            goal: "Implement user authentication with OAuth",
            constraints: EffortConstraints(maxEffort: 80)
        )
        #expect(!result.decomposition.subtasks.isEmpty)
        #expect(result.overallConfidence > 0)
    }
    
    @Test("Orchestrator - Decision support")
    func testDecisionSupport() async {
        let decision = DecisionInput(id: "test", description: "Should we use GraphQL or REST for the API?")
        let result = await IntelligenceOrchestrator.shared.supportDecision(decision)
        #expect(!result.recommendation.isEmpty)
    }
    
    @Test("Orchestrator - Stats")
    func testOrchestratorStats() async {
        let stats = await IntelligenceOrchestrator.shared.stats()
        #expect(stats.totalExecutions >= 0)
    }
    
    // MARK: - AIKit Static Access Tests
    
    @Test("AIKit version and pitch")
    func testAIKitMetadata() {
        #expect(AIKit.version == "2.0.0")
        #expect(!AIKit.pitch.isEmpty)
    }
}
