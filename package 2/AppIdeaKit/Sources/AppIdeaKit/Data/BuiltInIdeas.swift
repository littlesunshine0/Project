//
//  BuiltInIdeas.swift
//  AppIdeaKit - Pre-loaded App Ideas Catalog
//

import Foundation

// MARK: - Built-In Ideas

public actor BuiltInIdeas {
    public static let shared = BuiltInIdeas()
    
    private init() {}
    
    /// Load all built-in ideas into the store
    public func loadAll() async {
        for idea in allIdeas {
            _ = await IdeaStore.shared.save(idea)
        }
    }
    
    /// Get all built-in ideas without saving
    public var allIdeas: [AppIdea] {
        developerTools + aiFirstApps + productivityApps + learningApps + businessApps + consumerApps + metaApps + mlReasoningApps + codeIntelligenceApps + documentMLApps + productMLApps + personalIntelligenceApps + metaMLApps + reusableMLPackages + higherOrderReasoningApps + structuralIntelligenceApps + planningOptimizationApps + knowledgeMemoryApps + humanSkillApps + strategyMLApps + personalAugmentationApps + mlInfrastructureApps + composableMLBricks
    }
    
    // MARK: - Developer / Builder Tools
    
    public var developerTools: [AppIdea] {
        [
            createIdea(
                name: "ProjectBootstrapper",
                description: "CLI that generates repo structure, docs, CI, linting, and base packages from a short prompt",
                category: .cliTool,
                kind: .cli,
                type: .generator,
                features: [
                    ("Prompt Parser", "Parse natural language project descriptions", .critical),
                    ("Structure Generator", "Generate folder structure based on project type", .critical),
                    ("Doc Generator", "Auto-generate README, CONTRIBUTING, LICENSE", .high),
                    ("CI Setup", "Configure GitHub Actions, GitLab CI, etc.", .high),
                    ("Linting Config", "Set up ESLint, SwiftLint, etc.", .medium)
                ],
                kits: ["CommandKit", "DocKit", "ParseKit", "FileKit"]
            ),
            
            createIdea(
                name: "SpecToTasks",
                description: "Converts requirements.md into tickets, subtasks, and estimates automatically",
                category: .developerTool,
                kind: .package,
                type: .converter,
                features: [
                    ("Markdown Parser", "Parse requirements documents", .critical),
                    ("Task Extractor", "Extract actionable tasks from requirements", .critical),
                    ("Estimator", "ML-based effort estimation", .high),
                    ("Export", "Export to Jira, Linear, GitHub Issues", .medium)
                ],
                kits: ["ParseKit", "NLUKit", "LearnKit", "ExportKit"]
            ),
            
            createIdea(
                name: "UtilityRegistry",
                description: "Local or cloud registry of shared utilities (logging, config, auth, errors)",
                category: .developerTool,
                kind: .service,
                type: .manager,
                features: [
                    ("Registry", "Central registry of reusable utilities", .critical),
                    ("Version Control", "Track versions and dependencies", .high),
                    ("Search", "Find utilities by capability", .high),
                    ("Auto-Import", "One-click import into projects", .medium)
                ],
                kits: ["SearchKit", "IndexerKit", "FileKit", "NetworkKit"]
            ),
            
            createIdea(
                name: "ArchitectureDiff",
                description: "Compares intended architecture vs actual codebase and flags drift",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Architecture Parser", "Parse architecture diagrams/docs", .critical),
                    ("Code Analyzer", "Analyze actual code structure", .critical),
                    ("Drift Detection", "Identify deviations from intended design", .critical),
                    ("Reports", "Generate drift reports with recommendations", .high)
                ],
                kits: ["IndexerKit", "ParseKit", "DocKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "DependencyDecisionEngine",
                description: "Recommends libraries based on project goals (scale, speed, security)",
                category: .developerTool,
                kind: .package,
                type: .assistant,
                features: [
                    ("Goal Analysis", "Understand project requirements", .critical),
                    ("Library Database", "Curated database of libraries", .critical),
                    ("Scoring Engine", "Score libraries against goals", .high),
                    ("Comparison", "Side-by-side library comparison", .medium)
                ],
                kits: ["KnowledgeKit", "LearnKit", "SearchKit", "AIKit"]
            ),
            
            createIdea(
                name: "CodebaseMemory",
                description: "Creates a semantic 'memory' of a repo for faster onboarding and AI usage",
                category: .codeAnalysis,
                kind: .service,
                type: .engine,
                features: [
                    ("Code Indexing", "Deep index of all code", .critical),
                    ("Semantic Graph", "Build semantic relationships", .critical),
                    ("Query Interface", "Natural language queries", .high),
                    ("AI Context", "Provide context to AI tools", .high)
                ],
                kits: ["IndexerKit", "AIKit", "KnowledgeKit", "SearchKit"]
            )
        ]
    }
    
    // MARK: - AI-First Apps
    
    public var aiFirstApps: [AppIdea] {
        [
            createIdea(
                name: "IdeaToMVP",
                description: "Input an idea → outputs spec, design, tasks, and starter repo",
                category: .aiFirst,
                kind: .standalone,
                type: .generator,
                features: [
                    ("Idea Parser", "Parse and understand idea descriptions", .critical),
                    ("Spec Generator", "Generate detailed specifications", .critical),
                    ("Design Generator", "Create architecture and design docs", .critical),
                    ("Task Breakdown", "Break down into actionable tasks", .high),
                    ("Repo Generator", "Generate starter repository", .high)
                ],
                kits: ["AIKit", "DocKit", "NLUKit", "WorkflowKit", "AgentKit"]
            ),
            
            createIdea(
                name: "TechCoFounder",
                description: "AI that challenges assumptions, suggests pivots, and flags risks",
                category: .aiFirst,
                kind: .standalone,
                type: .assistant,
                features: [
                    ("Assumption Tracker", "Track and challenge assumptions", .critical),
                    ("Risk Analyzer", "Identify and assess risks", .critical),
                    ("Pivot Suggester", "Suggest strategic pivots", .high),
                    ("Decision Support", "Help with technical decisions", .high)
                ],
                kits: ["AIKit", "ChatKit", "KnowledgeKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "ContextDocBot",
                description: "Answers questions using only your repo + docs as context",
                category: .aiFirst,
                kind: .service,
                type: .assistant,
                features: [
                    ("Doc Indexer", "Index all documentation", .critical),
                    ("Code Indexer", "Index codebase", .critical),
                    ("QA Engine", "Answer questions from context", .critical),
                    ("Citation", "Cite sources in answers", .high)
                ],
                kits: ["AIKit", "KnowledgeKit", "IndexerKit", "ChatKit", "SearchKit"]
            ),
            
            createIdea(
                name: "RefactorAssistant",
                description: "Suggests modularization and reusable package extraction",
                category: .aiFirst,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Code Analysis", "Analyze code for patterns", .critical),
                    ("Duplication Finder", "Find duplicated logic", .critical),
                    ("Module Suggester", "Suggest module boundaries", .high),
                    ("Refactor Plans", "Generate refactoring plans", .high)
                ],
                kits: ["AIKit", "IndexerKit", "ParseKit", "SyntaxKit"]
            )
        ]
    }
    
    // MARK: - Productivity & Organization
    
    public var productivityApps: [AppIdea] {
        [
            createIdea(
                name: "GoalSystemBuilder",
                description: "Turns a goal into habits, tools, schedules, and metrics",
                category: .productivity,
                kind: .standalone,
                type: .builder,
                features: [
                    ("Goal Parser", "Parse and structure goals", .critical),
                    ("Habit Generator", "Generate supporting habits", .critical),
                    ("Schedule Builder", "Create optimal schedules", .high),
                    ("Metrics Tracker", "Track progress metrics", .high)
                ],
                kits: ["NLUKit", "WorkflowKit", "AnalyticsKit", "NotificationKit"]
            ),
            
            createIdea(
                name: "DecisionLog",
                description: "Records decisions, reasoning, and outcomes for teams",
                category: .organization,
                kind: .standalone,
                type: .tracker,
                features: [
                    ("Decision Capture", "Record decisions with context", .critical),
                    ("Reasoning Tracker", "Document reasoning", .critical),
                    ("Outcome Tracking", "Track decision outcomes", .high),
                    ("Search & Filter", "Find past decisions", .medium)
                ],
                kits: ["KnowledgeKit", "SearchKit", "CollaborationKit", "ExportKit"]
            ),
            
            createIdea(
                name: "KnowledgeCompiler",
                description: "Converts notes into structured frameworks automatically",
                category: .productivity,
                kind: .package,
                type: .converter,
                features: [
                    ("Note Parser", "Parse various note formats", .critical),
                    ("Structure Extractor", "Extract structure from notes", .critical),
                    ("Framework Builder", "Build knowledge frameworks", .high),
                    ("Export", "Export to various formats", .medium)
                ],
                kits: ["ParseKit", "KnowledgeKit", "NLUKit", "ExportKit"]
            )
        ]
    }
    
    // MARK: - Learning & Skill Building
    
    public var learningApps: [AppIdea] {
        [
            createIdea(
                name: "LearningPathGenerator",
                description: "Builds adaptive learning plans based on current skill level",
                category: .learning,
                kind: .standalone,
                type: .generator,
                features: [
                    ("Skill Assessment", "Assess current skill level", .critical),
                    ("Path Generator", "Generate personalized learning path", .critical),
                    ("Resource Finder", "Find learning resources", .high),
                    ("Progress Tracker", "Track learning progress", .high)
                ],
                kits: ["LearnKit", "KnowledgeKit", "AnalyticsKit", "UserKit"]
            ),
            
            createIdea(
                name: "ExplainMyCode",
                description: "Helps devs practice explaining their own code clearly",
                category: .skillBuilding,
                kind: .standalone,
                type: .assistant,
                features: [
                    ("Code Analyzer", "Analyze code for explanation", .critical),
                    ("Explanation Prompts", "Generate explanation prompts", .critical),
                    ("Feedback Engine", "Provide feedback on explanations", .high),
                    ("Progress Tracking", "Track improvement over time", .medium)
                ],
                kits: ["AIKit", "SyntaxKit", "FeedbackKit", "LearnKit"]
            ),
            
            createIdea(
                name: "MistakeTracker",
                description: "Identifies recurring mistakes and suggests targeted practice",
                category: .skillBuilding,
                kind: .package,
                type: .tracker,
                features: [
                    ("Mistake Logger", "Log and categorize mistakes", .critical),
                    ("Pattern Finder", "Find recurring patterns", .critical),
                    ("Practice Generator", "Generate targeted practice", .high),
                    ("Progress Reports", "Show improvement over time", .medium)
                ],
                kits: ["LearnKit", "AnalyticsKit", "FeedbackKit", "NotificationKit"]
            )
        ]
    }
    
    // MARK: - Startup / Business Tools
    
    public var businessApps: [AppIdea] {
        [
            createIdea(
                name: "InternalToolGenerator",
                description: "Auto-builds CRUD dashboards from database schemas",
                category: .business,
                kind: .standalone,
                type: .generator,
                features: [
                    ("Schema Parser", "Parse database schemas", .critical),
                    ("UI Generator", "Generate CRUD interfaces", .critical),
                    ("API Generator", "Generate REST/GraphQL APIs", .high),
                    ("Auth Integration", "Add authentication", .medium)
                ],
                kits: ["ParseKit", "DocKit", "WorkflowKit", "ExportKit"]
            ),
            
            createIdea(
                name: "FeatureROIAnalyzer",
                description: "Scores features by impact vs effort vs risk",
                category: .business,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Feature Input", "Input feature descriptions", .critical),
                    ("Impact Scorer", "Score potential impact", .critical),
                    ("Effort Estimator", "Estimate development effort", .high),
                    ("Risk Assessor", "Assess implementation risks", .high),
                    ("Prioritization", "Generate priority rankings", .medium)
                ],
                kits: ["AnalyticsKit", "LearnKit", "ExportKit", "FeedbackKit"]
            ),
            
            createIdea(
                name: "FeedbackSynthesizer",
                description: "Turns raw feedback into themes and action items",
                category: .business,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Feedback Ingestion", "Import feedback from sources", .critical),
                    ("Theme Extraction", "Extract common themes", .critical),
                    ("Sentiment Analysis", "Analyze sentiment", .high),
                    ("Action Generator", "Generate action items", .high)
                ],
                kits: ["FeedbackKit", "NLUKit", "AIKit", "ExportKit"]
            )
        ]
    }
    
    // MARK: - Consumer-Facing Apps
    
    public var consumerApps: [AppIdea] {
        [
            createIdea(
                name: "PersonalSystemsOS",
                description: "One app for goals, habits, projects, and reflections",
                category: .consumer,
                kind: .standalone,
                type: .manager,
                features: [
                    ("Goal Tracker", "Track and manage goals", .critical),
                    ("Habit System", "Build and track habits", .critical),
                    ("Project Manager", "Manage personal projects", .high),
                    ("Reflection Journal", "Daily/weekly reflections", .high),
                    ("Analytics", "Personal analytics dashboard", .medium)
                ],
                kits: ["UserKit", "AnalyticsKit", "NotificationKit", "WorkflowKit"]
            ),
            
            createIdea(
                name: "LifeAdminAssistant",
                description: "Handles reminders, planning, and follow-ups automatically",
                category: .assistant,
                kind: .standalone,
                type: .assistant,
                features: [
                    ("Smart Reminders", "Context-aware reminders", .critical),
                    ("Auto Planning", "Automatic schedule planning", .critical),
                    ("Follow-up Tracker", "Track and remind follow-ups", .high),
                    ("Integration", "Connect to calendars, email", .medium)
                ],
                kits: ["AgentKit", "NotificationKit", "WorkflowKit", "NLUKit"]
            ),
            
            createIdea(
                name: "SkillSwapMarketplace",
                description: "Trade skills instead of money (dev ↔ design ↔ marketing)",
                category: .marketplace,
                kind: .standalone,
                type: .marketplace,
                features: [
                    ("Skill Profiles", "Create skill profiles", .critical),
                    ("Matching Engine", "Match complementary skills", .critical),
                    ("Trade System", "Facilitate skill trades", .high),
                    ("Reviews", "Review and rating system", .medium)
                ],
                kits: ["MarketplaceKit", "UserKit", "SearchKit", "NotificationKit"]
            )
        ]
    }
    
    // MARK: - Meta-App Ideas
    
    public var metaApps: [AppIdea] {
        [
            createIdea(
                name: "PackageStarterKit",
                description: "Templates + rules for building reusable internal packages",
                category: .metaApp,
                kind: .template,
                type: .generator,
                features: [
                    ("Template Library", "Library of package templates", .critical),
                    ("Rule Engine", "Enforce package standards", .critical),
                    ("Generator", "Generate new packages", .high),
                    ("Validator", "Validate package structure", .medium)
                ],
                kits: ["DocKit", "ParseKit", "FileKit", "CommandKit"]
            ),
            
            createIdea(
                name: "CrossProjectExtractor",
                description: "Finds duplicated logic across repos and suggests shared modules",
                category: .metaApp,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Multi-Repo Scanner", "Scan multiple repositories", .critical),
                    ("Duplication Finder", "Find duplicated code", .critical),
                    ("Module Suggester", "Suggest shared modules", .high),
                    ("Extraction Helper", "Help extract shared code", .medium)
                ],
                kits: ["IndexerKit", "ParseKit", "AIKit", "FileKit"]
            ),
            
            createIdea(
                name: "AutomationComposer",
                description: "Visual rules engine that outputs code (not just workflows)",
                category: .metaApp,
                kind: .standalone,
                type: .builder,
                features: [
                    ("Visual Editor", "Visual rule composition", .critical),
                    ("Code Generator", "Generate code from rules", .critical),
                    ("Rule Library", "Library of reusable rules", .high),
                    ("Testing", "Test rules before deployment", .medium)
                ],
                kits: ["WorkflowKit", "CommandKit", "ParseKit", "ExportKit"]
            )
        ]
    }
    
    // MARK: - ML Core Reasoning / Understanding
    
    public var mlReasoningApps: [AppIdea] {
        [
            createIdea(
                name: "IdeaUnderstandingEngine",
                description: "Takes messy ideas → extracts intent, constraints, risks, and unknowns using ML",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Intent Extractor", "Extract core intent from messy descriptions", .critical),
                    ("Constraint Detector", "Identify explicit and implicit constraints", .critical),
                    ("Risk Identifier", "Flag potential risks and challenges", .high),
                    ("Unknown Mapper", "Map areas of uncertainty", .high)
                ],
                kits: ["AIKit", "NLUKit", "LearnKit", "KnowledgeKit"]
            ),
            
            createIdea(
                name: "RequirementInferenceModel",
                description: "Predicts missing requirements from partial specs or conversations",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Gap Detector", "Find missing requirements", .critical),
                    ("Inference Engine", "Predict likely requirements", .critical),
                    ("Confidence Scorer", "Score prediction confidence", .high),
                    ("Suggestion Generator", "Generate requirement suggestions", .high)
                ],
                kits: ["AIKit", "LearnKit", "NLUKit", "DocKit"]
            ),
            
            createIdea(
                name: "AssumptionDetector",
                description: "Flags hidden assumptions in specs, plans, or business ideas",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Assumption Scanner", "Scan text for implicit assumptions", .critical),
                    ("Risk Classifier", "Classify assumption risk levels", .critical),
                    ("Validation Suggester", "Suggest how to validate assumptions", .high),
                    ("Tracking", "Track assumption status over time", .medium)
                ],
                kits: ["AIKit", "NLUKit", "LearnKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "AmbiguityClassifier",
                description: "Scores documents for clarity and highlights vague sections",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Clarity Scorer", "Score overall document clarity", .critical),
                    ("Vagueness Highlighter", "Highlight ambiguous sections", .critical),
                    ("Rewrite Suggester", "Suggest clearer alternatives", .high),
                    ("Benchmark", "Compare against clarity benchmarks", .medium)
                ],
                kits: ["AIKit", "NLUKit", "ParseKit", "DocKit"]
            )
        ]
    }
    
    // MARK: - Code & Architecture Intelligence
    
    public var codeIntelligenceApps: [AppIdea] {
        [
            createIdea(
                name: "ArchitecturePatternClassifier",
                description: "Detects architecture style from a repo (MVC, Clean, Hexagonal, etc.)",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Pattern Detector", "Detect architecture patterns", .critical),
                    ("Style Classifier", "Classify architecture style", .critical),
                    ("Consistency Checker", "Check pattern consistency", .high),
                    ("Migration Advisor", "Advise on pattern migration", .medium)
                ],
                kits: ["IndexerKit", "ParseKit", "LearnKit", "AIKit"]
            ),
            
            createIdea(
                name: "RefactorOpportunityModel",
                description: "Predicts which modules should become reusable packages",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Reuse Scorer", "Score code reusability potential", .critical),
                    ("Boundary Detector", "Detect natural module boundaries", .critical),
                    ("Extraction Planner", "Plan extraction steps", .high),
                    ("Impact Analyzer", "Analyze extraction impact", .high)
                ],
                kits: ["IndexerKit", "ParseKit", "LearnKit", "AIKit"]
            ),
            
            createIdea(
                name: "TechDebtPredictor",
                description: "Forecasts future maintenance cost based on code patterns",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Debt Scorer", "Score current tech debt", .critical),
                    ("Cost Predictor", "Predict future maintenance cost", .critical),
                    ("Hotspot Finder", "Find high-debt hotspots", .high),
                    ("Remediation Planner", "Plan debt reduction", .medium)
                ],
                kits: ["IndexerKit", "LearnKit", "AnalyticsKit", "AIKit"]
            ),
            
            createIdea(
                name: "DependencyRiskScorer",
                description: "Scores third-party libraries for long-term risk",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Risk Scorer", "Score dependency risk", .critical),
                    ("Maintenance Predictor", "Predict maintenance status", .critical),
                    ("Alternative Finder", "Find safer alternatives", .high),
                    ("Update Advisor", "Advise on updates", .medium)
                ],
                kits: ["IndexerKit", "LearnKit", "WebKit", "AnalyticsKit"]
            )
        ]
    }
    
    // MARK: - Document & Knowledge ML
    
    public var documentMLApps: [AppIdea] {
        [
            createIdea(
                name: "SpecEvolutionModel",
                description: "Tracks how requirements change over time and predicts next changes",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Change Tracker", "Track spec changes over time", .critical),
                    ("Pattern Learner", "Learn change patterns", .critical),
                    ("Change Predictor", "Predict likely next changes", .high),
                    ("Impact Assessor", "Assess change impact", .high)
                ],
                kits: ["LearnKit", "DocKit", "CollaborationKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "DocCodeAlignmentModel",
                description: "Learns whether code still matches its documentation",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Alignment Scorer", "Score doc-code alignment", .critical),
                    ("Drift Detector", "Detect documentation drift", .critical),
                    ("Update Suggester", "Suggest doc updates", .high),
                    ("Sync Tracker", "Track sync status", .medium)
                ],
                kits: ["IndexerKit", "DocKit", "LearnKit", "AIKit"]
            ),
            
            createIdea(
                name: "KnowledgeGapDetector",
                description: "Finds what a team thinks is documented vs what actually is",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Coverage Analyzer", "Analyze documentation coverage", .critical),
                    ("Gap Finder", "Find undocumented areas", .critical),
                    ("Priority Ranker", "Rank gaps by importance", .high),
                    ("Template Generator", "Generate doc templates for gaps", .medium)
                ],
                kits: ["KnowledgeKit", "SearchKit", "LearnKit", "DocKit"]
            )
        ]
    }
    
    // MARK: - Product & Startup ML
    
    public var productMLApps: [AppIdea] {
        [
            createIdea(
                name: "FeatureImpactPredictor",
                description: "Predicts adoption or churn impact of proposed features",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Impact Predictor", "Predict feature impact", .critical),
                    ("Adoption Modeler", "Model adoption curves", .critical),
                    ("Churn Analyzer", "Analyze churn risk", .high),
                    ("ROI Calculator", "Calculate expected ROI", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "FeedbackKit"]
            ),
            
            createIdea(
                name: "FeedbackThemeLearner",
                description: "Discovers latent themes in reviews, issues, and support tickets",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Theme Extractor", "Extract themes from feedback", .critical),
                    ("Sentiment Analyzer", "Analyze sentiment per theme", .critical),
                    ("Trend Tracker", "Track theme trends", .high),
                    ("Action Generator", "Generate action items", .high)
                ],
                kits: ["NLUKit", "LearnKit", "FeedbackKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "IdeaViabilityScorer",
                description: "Scores ideas using historical startup data + heuristics",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Viability Scorer", "Score idea viability", .critical),
                    ("Market Analyzer", "Analyze market fit", .critical),
                    ("Risk Assessor", "Assess execution risks", .high),
                    ("Benchmark Comparer", "Compare to successful startups", .medium)
                ],
                kits: ["LearnKit", "KnowledgeKit", "AIKit", "AnalyticsKit"]
            )
        ]
    }
    
    // MARK: - Personal Intelligence Systems
    
    public var personalIntelligenceApps: [AppIdea] {
        [
            createIdea(
                name: "PersonalDecisionModel",
                description: "Learns your past decisions and predicts better options",
                category: .mlPowered,
                kind: .standalone,
                type: .assistant,
                features: [
                    ("Decision Logger", "Log decisions with context", .critical),
                    ("Pattern Learner", "Learn decision patterns", .critical),
                    ("Option Predictor", "Predict better options", .high),
                    ("Outcome Tracker", "Track decision outcomes", .high)
                ],
                kits: ["LearnKit", "UserKit", "KnowledgeKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "ContextMemoryEngine",
                description: "Builds long-term semantic memory from notes, code, and docs",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Memory Builder", "Build semantic memory graph", .critical),
                    ("Context Retriever", "Retrieve relevant context", .critical),
                    ("Connection Finder", "Find hidden connections", .high),
                    ("Forgetting Curve", "Manage memory decay", .medium)
                ],
                kits: ["KnowledgeKit", "AIKit", "IndexerKit", "SearchKit"]
            ),
            
            createIdea(
                name: "CognitiveLoadEstimator",
                description: "Predicts when a plan or system is too complex to sustain",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Complexity Scorer", "Score cognitive complexity", .critical),
                    ("Overload Predictor", "Predict cognitive overload", .critical),
                    ("Simplification Suggester", "Suggest simplifications", .high),
                    ("Capacity Tracker", "Track cognitive capacity", .medium)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "UserKit"]
            ),
            
            createIdea(
                name: "SkillProgressionModel",
                description: "Learns how fast someone improves and adjusts learning paths",
                category: .learning,
                kind: .package,
                type: .engine,
                features: [
                    ("Progress Tracker", "Track skill progression", .critical),
                    ("Rate Learner", "Learn improvement rate", .critical),
                    ("Path Adjuster", "Adjust learning paths", .high),
                    ("Plateau Detector", "Detect learning plateaus", .medium)
                ],
                kits: ["LearnKit", "UserKit", "AnalyticsKit", "FeedbackKit"]
            ),
            
            createIdea(
                name: "MistakePatternModel",
                description: "Detects recurring conceptual mistakes over time",
                category: .learning,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Mistake Logger", "Log mistakes with context", .critical),
                    ("Pattern Detector", "Detect recurring patterns", .critical),
                    ("Root Cause Finder", "Find root causes", .high),
                    ("Practice Generator", "Generate targeted practice", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "FeedbackKit", "AIKit"]
            ),
            
            createIdea(
                name: "ExplainabilityCoach",
                description: "Scores how well someone explains a concept or code",
                category: .learning,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Clarity Scorer", "Score explanation clarity", .critical),
                    ("Gap Finder", "Find explanation gaps", .critical),
                    ("Improvement Suggester", "Suggest improvements", .high),
                    ("Progress Tracker", "Track explanation skills", .medium)
                ],
                kits: ["NLUKit", "AIKit", "LearnKit", "FeedbackKit"]
            )
        ]
    }
    
    // MARK: - Meta / Platform ML
    
    public var metaMLApps: [AppIdea] {
        [
            createIdea(
                name: "AutoModelSelector",
                description: "Chooses the best ML model + features for a given problem",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Problem Analyzer", "Analyze ML problem type", .critical),
                    ("Model Recommender", "Recommend best models", .critical),
                    ("Feature Suggester", "Suggest optimal features", .high),
                    ("Benchmark Runner", "Run model benchmarks", .high)
                ],
                kits: ["LearnKit", "AIKit", "AnalyticsKit", "IndexerKit"]
            ),
            
            createIdea(
                name: "TrainingDataAnalyzer",
                description: "Detects bias, leakage, and weak signals in datasets",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Bias Detector", "Detect data bias", .critical),
                    ("Leakage Finder", "Find data leakage", .critical),
                    ("Signal Analyzer", "Analyze signal strength", .high),
                    ("Quality Scorer", "Score dataset quality", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "ParseKit"]
            ),
            
            createIdea(
                name: "PromptToModelCompiler",
                description: "Converts natural language goals into ML pipelines",
                category: .mlPowered,
                kind: .package,
                type: .compiler,
                features: [
                    ("Goal Parser", "Parse ML goals from text", .critical),
                    ("Pipeline Generator", "Generate ML pipelines", .critical),
                    ("Config Optimizer", "Optimize pipeline config", .high),
                    ("Code Exporter", "Export runnable code", .high)
                ],
                kits: ["NLUKit", "AIKit", "LearnKit", "ExportKit"]
            )
        ]
    }
    
    // MARK: - Reusable ML Packages
    
    public var reusableMLPackages: [AppIdea] {
        [
            createIdea(
                name: "TextUnderstandingCore",
                description: "Reusable package for intent extraction, entity detection, ambiguity scoring",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Intent Extractor", "Extract intents from text", .critical),
                    ("Entity Detector", "Detect named entities", .critical),
                    ("Ambiguity Scorer", "Score text ambiguity", .high),
                    ("Sentiment Analyzer", "Analyze sentiment", .medium)
                ],
                kits: ["NLUKit", "AIKit", "LearnKit"]
            ),
            
            createIdea(
                name: "SemanticSimilarityEngine",
                description: "Cross-doc, cross-code, cross-idea comparison engine",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Embedding Generator", "Generate semantic embeddings", .critical),
                    ("Similarity Scorer", "Score semantic similarity", .critical),
                    ("Cluster Finder", "Find similar clusters", .high),
                    ("Diff Analyzer", "Analyze semantic differences", .medium)
                ],
                kits: ["AIKit", "SearchKit", "IndexerKit", "LearnKit"]
            ),
            
            createIdea(
                name: "ChangeDetectionEngine",
                description: "Learns meaningful vs noisy changes across documents and code",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Change Detector", "Detect changes", .critical),
                    ("Significance Scorer", "Score change significance", .critical),
                    ("Noise Filter", "Filter noisy changes", .high),
                    ("Impact Predictor", "Predict change impact", .high)
                ],
                kits: ["LearnKit", "ParseKit", "CollaborationKit", "IndexerKit"]
            ),
            
            createIdea(
                name: "RiskUncertaintyScorer",
                description: "Outputs confidence intervals, not just predictions - for any ML model",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Uncertainty Quantifier", "Quantify prediction uncertainty", .critical),
                    ("Confidence Interval", "Generate confidence intervals", .critical),
                    ("Calibration Checker", "Check model calibration", .high),
                    ("Risk Aggregator", "Aggregate risk scores", .medium)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit"]
            )
        ]
    }
    
    // MARK: - Higher-Order Reasoning & Meta-Cognition
    
    public var higherOrderReasoningApps: [AppIdea] {
        [
            createIdea(
                name: "UncertaintyAwarePlanner",
                description: "Predicts confidence ranges and failure modes for plans, not just outcomes",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Confidence Ranger", "Generate confidence ranges for plans", .critical),
                    ("Failure Mode Predictor", "Predict likely failure modes", .critical),
                    ("Scenario Simulator", "Simulate plan scenarios", .high),
                    ("Risk Mitigator", "Suggest risk mitigations", .high)
                ],
                kits: ["LearnKit", "AIKit", "AnalyticsKit", "WorkflowKit"]
            ),
            
            createIdea(
                name: "ContradictionDetectionEngine",
                description: "Finds logical conflicts across specs, docs, code, and conversations",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Conflict Scanner", "Scan for logical conflicts", .critical),
                    ("Cross-Source Analyzer", "Analyze across multiple sources", .critical),
                    ("Resolution Suggester", "Suggest conflict resolutions", .high),
                    ("Consistency Tracker", "Track consistency over time", .medium)
                ],
                kits: ["AIKit", "NLUKit", "IndexerKit", "KnowledgeKit"]
            ),
            
            createIdea(
                name: "BeliefRevisionModel",
                description: "Learns when new information should override old assumptions",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Belief Tracker", "Track beliefs and assumptions", .critical),
                    ("Override Detector", "Detect when to override beliefs", .critical),
                    ("Confidence Updater", "Update belief confidence", .high),
                    ("History Maintainer", "Maintain belief history", .medium)
                ],
                kits: ["LearnKit", "KnowledgeKit", "AIKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "DecisionTraceLearner",
                description: "Learns which reasoning paths lead to good vs bad outcomes",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Trace Recorder", "Record decision reasoning traces", .critical),
                    ("Outcome Correlator", "Correlate traces with outcomes", .critical),
                    ("Pattern Extractor", "Extract successful patterns", .high),
                    ("Recommendation Engine", "Recommend better paths", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "KnowledgeKit", "AIKit"]
            )
        ]
    }
    
    // MARK: - Structural & Systems Intelligence
    
    public var structuralIntelligenceApps: [AppIdea] {
        [
            createIdea(
                name: "SystemComplexityEstimator",
                description: "Predicts when a system crosses the 'too complex to maintain' threshold",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Complexity Scorer", "Score system complexity", .critical),
                    ("Threshold Predictor", "Predict complexity thresholds", .critical),
                    ("Simplification Advisor", "Advise on simplification", .high),
                    ("Trend Tracker", "Track complexity trends", .medium)
                ],
                kits: ["IndexerKit", "LearnKit", "AnalyticsKit", "AIKit"]
            ),
            
            createIdea(
                name: "CouplingCohesionModel",
                description: "Learns healthy vs unhealthy module boundaries from large repos",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Coupling Analyzer", "Analyze module coupling", .critical),
                    ("Cohesion Scorer", "Score module cohesion", .critical),
                    ("Boundary Suggester", "Suggest better boundaries", .high),
                    ("Health Benchmarker", "Benchmark against healthy repos", .medium)
                ],
                kits: ["IndexerKit", "LearnKit", "ParseKit", "AIKit"]
            ),
            
            createIdea(
                name: "ArchitectureStabilityPredictor",
                description: "Forecasts how likely an architecture is to survive feature growth",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Stability Scorer", "Score architecture stability", .critical),
                    ("Growth Simulator", "Simulate feature growth impact", .critical),
                    ("Weakness Finder", "Find architectural weaknesses", .high),
                    ("Evolution Advisor", "Advise on architecture evolution", .high)
                ],
                kits: ["IndexerKit", "LearnKit", "AIKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "ReusableBoundaryDetector",
                description: "Identifies logic that should live in shared packages",
                category: .codeAnalysis,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Boundary Detector", "Detect reusable boundaries", .critical),
                    ("Extraction Scorer", "Score extraction candidates", .critical),
                    ("Dependency Analyzer", "Analyze extraction dependencies", .high),
                    ("Package Planner", "Plan package extraction", .high)
                ],
                kits: ["IndexerKit", "ParseKit", "LearnKit", "AIKit"]
            )
        ]
    }
    
    // MARK: - Planning, Scheduling & Optimization
    
    public var planningOptimizationApps: [AppIdea] {
        [
            createIdea(
                name: "TaskDecompositionLearner",
                description: "Learns how experts break large goals into executable steps",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Decomposition Learner", "Learn expert decomposition patterns", .critical),
                    ("Step Generator", "Generate executable steps", .critical),
                    ("Granularity Optimizer", "Optimize step granularity", .high),
                    ("Dependency Mapper", "Map step dependencies", .high)
                ],
                kits: ["LearnKit", "WorkflowKit", "AIKit", "NLUKit"]
            ),
            
            createIdea(
                name: "EstimateAccuracyModel",
                description: "Predicts which estimates will be wrong before execution",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Accuracy Predictor", "Predict estimate accuracy", .critical),
                    ("Risk Flagger", "Flag high-risk estimates", .critical),
                    ("Calibration Suggester", "Suggest estimate calibration", .high),
                    ("Historical Analyzer", "Analyze historical accuracy", .medium)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "WorkflowKit"]
            ),
            
            createIdea(
                name: "CriticalPathRiskPredictor",
                description: "Learns where plans tend to break",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Risk Predictor", "Predict critical path risks", .critical),
                    ("Bottleneck Finder", "Find likely bottlenecks", .critical),
                    ("Mitigation Planner", "Plan risk mitigations", .high),
                    ("Alternative Suggester", "Suggest alternative paths", .high)
                ],
                kits: ["LearnKit", "WorkflowKit", "AnalyticsKit", "AIKit"]
            ),
            
            createIdea(
                name: "EffortOutcomeOptimizer",
                description: "Suggests the smallest viable effort for a desired result",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Effort Minimizer", "Minimize effort for outcomes", .critical),
                    ("ROI Optimizer", "Optimize effort-to-outcome ratio", .critical),
                    ("Scope Trimmer", "Suggest scope reductions", .high),
                    ("Impact Predictor", "Predict outcome impact", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "WorkflowKit"]
            )
        ]
    }
    
    // MARK: - Knowledge & Memory Systems
    
    public var knowledgeMemoryApps: [AppIdea] {
        [
            createIdea(
                name: "SemanticProjectMemory",
                description: "Learns what information matters long-term vs noise",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Importance Scorer", "Score information importance", .critical),
                    ("Memory Curator", "Curate long-term memory", .critical),
                    ("Noise Filter", "Filter out noise", .high),
                    ("Retrieval Optimizer", "Optimize memory retrieval", .high)
                ],
                kits: ["KnowledgeKit", "LearnKit", "AIKit", "SearchKit"]
            ),
            
            createIdea(
                name: "KnowledgeDecayPredictor",
                description: "Predicts what docs or code will become outdated soon",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Decay Predictor", "Predict knowledge decay", .critical),
                    ("Staleness Scorer", "Score content staleness", .critical),
                    ("Update Prioritizer", "Prioritize updates", .high),
                    ("Freshness Tracker", "Track content freshness", .medium)
                ],
                kits: ["LearnKit", "DocKit", "IndexerKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "ContextCompressionModel",
                description: "Compresses large histories into durable, retrievable knowledge",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("History Compressor", "Compress large histories", .critical),
                    ("Key Extractor", "Extract key information", .critical),
                    ("Retrieval Indexer", "Index for fast retrieval", .high),
                    ("Lossless Summarizer", "Summarize without loss", .high)
                ],
                kits: ["AIKit", "KnowledgeKit", "LearnKit", "SearchKit"]
            ),
            
            createIdea(
                name: "CrossDomainInsightFinder",
                description: "Transfers patterns from one domain to another",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Pattern Extractor", "Extract domain patterns", .critical),
                    ("Transfer Mapper", "Map patterns across domains", .critical),
                    ("Insight Generator", "Generate cross-domain insights", .high),
                    ("Analogy Finder", "Find useful analogies", .high)
                ],
                kits: ["AIKit", "LearnKit", "KnowledgeKit", "SearchKit"]
            )
        ]
    }
    
    // MARK: - Learning, Training & Human Skill Models
    
    public var humanSkillApps: [AppIdea] {
        [
            createIdea(
                name: "CognitiveSkillTransferModel",
                description: "Predicts which skills accelerate learning others",
                category: .learning,
                kind: .package,
                type: .engine,
                features: [
                    ("Transfer Predictor", "Predict skill transfer", .critical),
                    ("Prerequisite Mapper", "Map skill prerequisites", .critical),
                    ("Learning Path Optimizer", "Optimize learning paths", .high),
                    ("Synergy Finder", "Find skill synergies", .high)
                ],
                kits: ["LearnKit", "KnowledgeKit", "AIKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "ErrorRootCauseLearner",
                description: "Learns why mistakes occur, not just that they do",
                category: .learning,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Root Cause Analyzer", "Analyze error root causes", .critical),
                    ("Pattern Correlator", "Correlate error patterns", .critical),
                    ("Prevention Suggester", "Suggest prevention strategies", .high),
                    ("Causal Graph Builder", "Build causal graphs", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "FeedbackKit"]
            ),
            
            createIdea(
                name: "ExpertImitationModel",
                description: "Learns patterns from top performers and generalizes them",
                category: .learning,
                kind: .package,
                type: .engine,
                features: [
                    ("Expert Analyzer", "Analyze expert behavior", .critical),
                    ("Pattern Generalizer", "Generalize expert patterns", .critical),
                    ("Skill Extractor", "Extract teachable skills", .high),
                    ("Adaptation Engine", "Adapt patterns to learners", .high)
                ],
                kits: ["LearnKit", "AIKit", "KnowledgeKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "MentalModelAlignmentScorer",
                description: "Measures how close someone's understanding is to reality",
                category: .learning,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Model Extractor", "Extract mental models", .critical),
                    ("Reality Comparer", "Compare to ground truth", .critical),
                    ("Gap Identifier", "Identify understanding gaps", .high),
                    ("Correction Suggester", "Suggest corrections", .high)
                ],
                kits: ["AIKit", "LearnKit", "NLUKit", "FeedbackKit"]
            )
        ]
    }
    
    // MARK: - Product, Market & Strategy ML
    
    public var strategyMLApps: [AppIdea] {
        [
            createIdea(
                name: "StrategySimulationModel",
                description: "Simulates outcomes of strategic choices over time",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Strategy Simulator", "Simulate strategic outcomes", .critical),
                    ("Timeline Projector", "Project outcomes over time", .critical),
                    ("Scenario Comparator", "Compare strategy scenarios", .high),
                    ("Risk Assessor", "Assess strategic risks", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit", "WorkflowKit"]
            ),
            
            createIdea(
                name: "FeatureSaturationDetector",
                description: "Predicts when features stop adding value",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Saturation Detector", "Detect feature saturation", .critical),
                    ("Value Curve Modeler", "Model diminishing returns", .critical),
                    ("Pivot Suggester", "Suggest when to pivot", .high),
                    ("Investment Optimizer", "Optimize feature investment", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "FeedbackKit", "AIKit"]
            ),
            
            createIdea(
                name: "MarketTimingPredictor",
                description: "Learns when an idea is too early vs too late",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Timing Analyzer", "Analyze market timing", .critical),
                    ("Readiness Scorer", "Score market readiness", .critical),
                    ("Window Predictor", "Predict opportunity windows", .high),
                    ("Trend Correlator", "Correlate with market trends", .high)
                ],
                kits: ["LearnKit", "WebKit", "AnalyticsKit", "AIKit"]
            ),
            
            createIdea(
                name: "UserIntentDriftModel",
                description: "Detects when user needs are changing",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Drift Detector", "Detect intent drift", .critical),
                    ("Trend Analyzer", "Analyze need trends", .critical),
                    ("Early Warning", "Provide early warnings", .high),
                    ("Adaptation Suggester", "Suggest adaptations", .high)
                ],
                kits: ["LearnKit", "NLUKit", "AnalyticsKit", "FeedbackKit"]
            )
        ]
    }
    
    // MARK: - Personal Intelligence / Augmentation
    
    public var personalAugmentationApps: [AppIdea] {
        [
            createIdea(
                name: "PersonalBiasDetector",
                description: "Learns an individual's recurring cognitive biases",
                category: .mlPowered,
                kind: .standalone,
                type: .analyzer,
                features: [
                    ("Bias Detector", "Detect cognitive biases", .critical),
                    ("Pattern Learner", "Learn bias patterns", .critical),
                    ("Debiasing Suggester", "Suggest debiasing strategies", .high),
                    ("Progress Tracker", "Track bias reduction", .medium)
                ],
                kits: ["LearnKit", "UserKit", "AIKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "DecisionFatiguePredictor",
                description: "Predicts when decision quality degrades",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Fatigue Predictor", "Predict decision fatigue", .critical),
                    ("Quality Tracker", "Track decision quality", .critical),
                    ("Break Suggester", "Suggest optimal breaks", .high),
                    ("Load Balancer", "Balance decision load", .medium)
                ],
                kits: ["LearnKit", "UserKit", "AnalyticsKit", "NotificationKit"]
            ),
            
            createIdea(
                name: "PersonalSystemsOptimizer",
                description: "Continuously refines habits, workflows, and tools",
                category: .mlPowered,
                kind: .standalone,
                type: .engine,
                features: [
                    ("System Analyzer", "Analyze personal systems", .critical),
                    ("Optimization Engine", "Optimize continuously", .critical),
                    ("Experiment Runner", "Run system experiments", .high),
                    ("Impact Measurer", "Measure optimization impact", .high)
                ],
                kits: ["LearnKit", "UserKit", "WorkflowKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "LifeTradeoffSimulator",
                description: "Simulates long-term impact of choices",
                category: .mlPowered,
                kind: .standalone,
                type: .engine,
                features: [
                    ("Tradeoff Modeler", "Model life tradeoffs", .critical),
                    ("Impact Simulator", "Simulate long-term impact", .critical),
                    ("Scenario Comparator", "Compare life scenarios", .high),
                    ("Regret Minimizer", "Minimize potential regret", .high)
                ],
                kits: ["LearnKit", "AIKit", "UserKit", "AnalyticsKit"]
            )
        ]
    }
    
    // MARK: - ML Infrastructure & Meta-Tools
    
    public var mlInfrastructureApps: [AppIdea] {
        [
            createIdea(
                name: "AutoFeatureDiscoveryEngine",
                description: "Learns useful features instead of hand-engineering",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Feature Discoverer", "Discover useful features", .critical),
                    ("Importance Ranker", "Rank feature importance", .critical),
                    ("Combination Explorer", "Explore feature combinations", .high),
                    ("Validation Engine", "Validate discovered features", .high)
                ],
                kits: ["LearnKit", "AIKit", "AnalyticsKit", "ParseKit"]
            ),
            
            createIdea(
                name: "ModelFailurePatternMiner",
                description: "Learns how and why models fail in production",
                category: .mlPowered,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Failure Miner", "Mine failure patterns", .critical),
                    ("Root Cause Analyzer", "Analyze failure causes", .critical),
                    ("Prevention Suggester", "Suggest failure prevention", .high),
                    ("Monitoring Advisor", "Advise on monitoring", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "ErrorKit", "AIKit"]
            ),
            
            createIdea(
                name: "DataScarcityLearner",
                description: "Performs well with extremely small datasets",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Few-Shot Learner", "Learn from few examples", .critical),
                    ("Transfer Leverager", "Leverage transfer learning", .critical),
                    ("Augmentation Engine", "Augment small datasets", .high),
                    ("Confidence Calibrator", "Calibrate with uncertainty", .high)
                ],
                kits: ["LearnKit", "AIKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "HumanInLoopOptimizer",
                description: "Learns when to ask for human input",
                category: .mlPowered,
                kind: .package,
                type: .engine,
                features: [
                    ("Uncertainty Detector", "Detect when uncertain", .critical),
                    ("Query Optimizer", "Optimize human queries", .critical),
                    ("Feedback Integrator", "Integrate human feedback", .high),
                    ("Autonomy Balancer", "Balance autonomy vs queries", .high)
                ],
                kits: ["LearnKit", "AIKit", "FeedbackKit", "UserKit"]
            )
        ]
    }
    
    // MARK: - Composable ML Bricks
    
    public var composableMLBricks: [AppIdea] {
        [
            createIdea(
                name: "UncertaintyEngine",
                description: "Reusable confidence, entropy, and risk scoring for any prediction",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Confidence Scorer", "Score prediction confidence", .critical),
                    ("Entropy Calculator", "Calculate prediction entropy", .critical),
                    ("Risk Quantifier", "Quantify prediction risk", .high),
                    ("Calibration Module", "Calibrate uncertainty estimates", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit"]
            ),
            
            createIdea(
                name: "ChangeIntelligenceModule",
                description: "Reusable signal vs noise detection for any change stream",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Signal Detector", "Detect meaningful signals", .critical),
                    ("Noise Filter", "Filter out noise", .critical),
                    ("Trend Identifier", "Identify change trends", .high),
                    ("Anomaly Flagger", "Flag anomalous changes", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "ParseKit"]
            ),
            
            createIdea(
                name: "StructureLearner",
                description: "Reusable graph, hierarchy, and boundary learning",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Graph Learner", "Learn graph structures", .critical),
                    ("Hierarchy Detector", "Detect hierarchies", .critical),
                    ("Boundary Finder", "Find natural boundaries", .high),
                    ("Relationship Mapper", "Map relationships", .high)
                ],
                kits: ["LearnKit", "IndexerKit", "AIKit"]
            ),
            
            createIdea(
                name: "MemoryRetrievalCore",
                description: "Reusable long-term semantic memory with intelligent retrieval",
                category: .framework,
                kind: .package,
                type: .engine,
                features: [
                    ("Memory Store", "Store semantic memories", .critical),
                    ("Retrieval Engine", "Retrieve relevant memories", .critical),
                    ("Decay Manager", "Manage memory decay", .high),
                    ("Association Builder", "Build memory associations", .high)
                ],
                kits: ["KnowledgeKit", "SearchKit", "AIKit", "LearnKit"]
            ),
            
            createIdea(
                name: "EvaluationIntelligence",
                description: "Knows when metrics lie - meta-evaluation for any ML system",
                category: .framework,
                kind: .package,
                type: .analyzer,
                features: [
                    ("Metric Validator", "Validate metric reliability", .critical),
                    ("Bias Detector", "Detect metric bias", .critical),
                    ("Alternative Suggester", "Suggest better metrics", .high),
                    ("Ground Truth Estimator", "Estimate ground truth", .high)
                ],
                kits: ["LearnKit", "AnalyticsKit", "AIKit"]
            )
        ]
    }
    
    // MARK: - Helper
    
    private func createIdea(
        name: String,
        description: String,
        category: AppCategory,
        kind: AppKind,
        type: AppType,
        features: [(String, String, Priority)],
        kits: [String]
    ) -> AppIdea {
        var idea = AppIdea(
            name: name,
            description: description,
            category: category,
            kind: kind,
            type: type
        )
        
        idea.features = features.map { Feature(name: $0.0, description: $0.1, priority: $0.2) }
        idea.suggestedKits = kits
        idea.status = .validated
        
        return idea
    }
}
