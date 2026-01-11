# AppIdeaKit

App Idea Management & Automated Generation System. Store app ideas with rich metadata, analyze with ML, and automatically generate apps using the Kit ecosystem.

## Features

- **Idea Storage**: Persistent storage with category, kind, type, and deep context
- **ML Analysis**: Automatic keyword extraction, kit suggestion, complexity prediction
- **App Generation**: Generate complete app scaffolds from ideas
- **Kit Catalog**: 30+ built-in Kits automatically suggested based on idea analysis
- **Built-in Ideas**: 22+ pre-loaded app ideas across 7 categories

## Quick Start

```swift
import AppIdeaKit

// Create an idea with auto-analysis
let idea = await AppIdeaKit.shared.createIdea(
    name: "CodeAnalyzer",
    description: "AI-powered code analyzer that finds bugs automatically",
    category: .aiFirst
)

// Or quick create with auto-detection
let idea = await AppIdeaKit.shared.quickCreate(
    name: "WorkflowEngine",
    description: "An automation workflow engine with AI capabilities"
)

// Generate an app from the idea
let result = await AppIdeaKit.shared.generateApp(from: idea)
// result.files contains Package.swift, README.md, specs, etc.
```

## Idea Categories

| Category | Description |
|----------|-------------|
| Developer Tool | Tools for developers |
| Builder Tool | Project/code builders |
| CLI Tool | Command-line interfaces |
| Code Analysis | Code analyzers and linters |
| Documentation | Doc generators |
| AI-First | AI-powered applications |
| ML-Powered | Machine learning apps |
| Automation | Workflow automation |
| Assistant | AI assistants |
| Productivity | Productivity tools |
| Organization | Organization tools |
| Planning | Planning tools |
| Tracking | Tracking systems |
| Learning | Learning platforms |
| Skill Building | Skill development |
| Education | Educational apps |
| Startup | Startup tools |
| Business | Business applications |
| Enterprise | Enterprise software |
| Marketplace | Marketplace apps |
| Consumer | Consumer apps |
| Lifestyle | Lifestyle apps |
| Social | Social platforms |
| Meta-App | Apps that build apps |
| Framework | Frameworks |
| Platform | Platforms |

## App Kinds

- **Standalone App** - Complete application
- **Package** - Reusable Swift package
- **CLI** - Command-line tool
- **Service** - Background service
- **Plugin** - Plugin/extension
- **Widget** - Widget component
- **API** - API service
- **Library** - Code library
- **Framework** - Framework
- **Template** - Project template

## App Types

- **Utility** - General utility
- **Generator** - Code/content generator
- **Analyzer** - Analysis tool
- **Converter** - Format converter
- **Manager** - Resource manager
- **Tracker** - Tracking system
- **Builder** - Builder tool
- **Assistant** - AI assistant
- **Dashboard** - Analytics dashboard
- **Marketplace** - Marketplace
- **Engine** - Processing engine
- **Compiler** - Compiler/transpiler
- **Orchestrator** - Workflow orchestrator

## ML Analysis

AppIdeaKit automatically analyzes ideas to:

1. **Extract Keywords** - Identify key technical terms
2. **Suggest Kits** - Recommend relevant Kits from the 30+ available
3. **Predict Complexity** - Estimate development effort
4. **Extract Topics** - Categorize by topic
5. **Calculate Confidence** - Score analysis confidence

## Built-in Ideas (86 Total)

### Developer Tools (6)
- ProjectBootstrapper - CLI for repo scaffolding
- SpecToTasks - Requirements to tickets converter
- UtilityRegistry - Shared utilities registry
- ArchitectureDiff - Architecture drift detector
- DependencyDecisionEngine - Library recommender
- CodebaseMemory - Semantic repo memory

### AI-First Apps (4)
- IdeaToMVP - Idea to starter repo generator
- TechCoFounder - AI technical advisor
- ContextDocBot - Repo-aware documentation bot
- RefactorAssistant - Code modularization assistant

### Productivity (3)
- GoalSystemBuilder - Goal to habits converter
- DecisionLog - Team decision tracker
- KnowledgeCompiler - Notes to frameworks converter

### Learning (3)
- LearningPathGenerator - Adaptive learning plans
- ExplainMyCode - Code explanation trainer
- MistakeTracker - Recurring mistake identifier

### Business (3)
- InternalToolGenerator - CRUD dashboard generator
- FeatureROIAnalyzer - Feature prioritization
- FeedbackSynthesizer - Feedback to action items

### Consumer (3)
- PersonalSystemsOS - Personal productivity OS
- LifeAdminAssistant - Automated life admin
- SkillSwapMarketplace - Skill trading platform

### Meta-Apps (3)
- PackageStarterKit - Package templates
- CrossProjectExtractor - Shared code finder
- AutomationComposer - Visual rules to code

### ML Core Reasoning (4)
- IdeaUnderstandingEngine - Extract intent, constraints, risks from messy ideas
- RequirementInferenceModel - Predict missing requirements
- AssumptionDetector - Flag hidden assumptions in specs
- AmbiguityClassifier - Score document clarity

### Code & Architecture Intelligence (4)
- ArchitecturePatternClassifier - Detect architecture style (MVC, Clean, etc.)
- RefactorOpportunityModel - Predict reusable package candidates
- TechDebtPredictor - Forecast maintenance cost
- DependencyRiskScorer - Score library long-term risk

### Document & Knowledge ML (3)
- SpecEvolutionModel - Track and predict requirement changes
- DocCodeAlignmentModel - Detect doc-code drift
- KnowledgeGapDetector - Find undocumented areas

### Product & Startup ML (3)
- FeatureImpactPredictor - Predict adoption/churn impact
- FeedbackThemeLearner - Discover latent themes in feedback
- IdeaViabilityScorer - Score startup idea viability

### Personal Intelligence (6)
- PersonalDecisionModel - Learn and predict better decisions
- ContextMemoryEngine - Build semantic memory from notes/code
- CognitiveLoadEstimator - Predict complexity overload
- SkillProgressionModel - Adjust learning paths by progress
- MistakePatternModel - Detect recurring conceptual mistakes
- ExplainabilityCoach - Score explanation quality

### Meta/Platform ML (3)
- AutoModelSelector - Choose best ML model for problem
- TrainingDataAnalyzer - Detect bias, leakage in datasets
- PromptToModelCompiler - Convert goals to ML pipelines

### Reusable ML Packages (4)
- TextUnderstandingCore - Intent, entity, ambiguity scoring
- SemanticSimilarityEngine - Cross-doc/code comparison
- ChangeDetectionEngine - Meaningful vs noisy change detection
- RiskUncertaintyScorer - Confidence intervals for predictions

### Higher-Order Reasoning (4)
- UncertaintyAwarePlanner - Confidence ranges and failure modes for plans
- ContradictionDetectionEngine - Find logical conflicts across sources
- BeliefRevisionModel - When new info should override assumptions
- DecisionTraceLearner - Which reasoning paths lead to good outcomes

### Structural Intelligence (4)
- SystemComplexityEstimator - Predict "too complex to maintain" threshold
- CouplingCohesionModel - Learn healthy vs unhealthy module boundaries
- ArchitectureStabilityPredictor - Forecast architecture survival
- ReusableBoundaryDetector - Identify shared package candidates

### Planning & Optimization (4)
- TaskDecompositionLearner - Learn expert goal decomposition
- EstimateAccuracyModel - Predict which estimates will be wrong
- CriticalPathRiskPredictor - Learn where plans break
- EffortOutcomeOptimizer - Smallest effort for desired result

### Knowledge & Memory (4)
- SemanticProjectMemory - What matters long-term vs noise
- KnowledgeDecayPredictor - Predict outdated docs/code
- ContextCompressionModel - Compress histories into retrievable knowledge
- CrossDomainInsightFinder - Transfer patterns across domains

### Human Skill Models (4)
- CognitiveSkillTransferModel - Which skills accelerate others
- ErrorRootCauseLearner - Why mistakes occur, not just that they do
- ExpertImitationModel - Learn and generalize expert patterns
- MentalModelAlignmentScorer - How close understanding is to reality

### Strategy ML (4)
- StrategySimulationModel - Simulate strategic outcomes over time
- FeatureSaturationDetector - When features stop adding value
- MarketTimingPredictor - Too early vs too late
- UserIntentDriftModel - Detect changing user needs

### Personal Augmentation (4)
- PersonalBiasDetector - Learn recurring cognitive biases
- DecisionFatiguePredictor - When decision quality degrades
- PersonalSystemsOptimizer - Continuously refine habits/workflows
- LifeTradeoffSimulator - Long-term impact of choices

### ML Infrastructure (4)
- AutoFeatureDiscoveryEngine - Learn features vs hand-engineering
- ModelFailurePatternMiner - How and why models fail
- DataScarcityLearner - Perform well with tiny datasets
- HumanInLoopOptimizer - When to ask for human input

### Composable ML Bricks (5)
- UncertaintyEngine - Confidence, entropy, risk for any prediction
- ChangeIntelligenceModule - Signal vs noise for any change stream
- StructureLearner - Graph, hierarchy, boundary learning
- MemoryRetrievalCore - Long-term semantic memory
- EvaluationIntelligence - Know when metrics lie

## Auto-Attach Kits

These Kits are automatically attached to every generated project:

- **IdeaKit** - Project Operating System
- **IconKit** - Universal icon system
- **ContentHub** - Centralized storage
- **BridgeKit** - Kit orchestration
- **DocKit** - Documentation generation

## Tests

17 tests covering:
- Idea creation and retrieval
- ML analysis and enrichment
- App generation
- Kit catalog
- Built-in ideas

---

Part of the FlowKit ecosystem.
