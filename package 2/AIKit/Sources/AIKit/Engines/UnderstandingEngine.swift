//
//  UnderstandingEngine.swift
//  AIKit - Core Intelligence Engine #1
//
//  Purpose: Turn unstructured input into structured meaning
//  Capabilities: Intent extraction, requirement inference, ambiguity detection,
//                assumption detection, contradiction detection
//

import Foundation

// MARK: - Understanding Engine

/// Core Engine #1: Transforms unstructured input into structured meaning
public actor UnderstandingEngine {
    public static let shared = UnderstandingEngine()
    
    private var analysisCache: [String: UnderstandingResult] = [:]
    private var intentModels: [String: IntentModel]
    private var executionLog: [UnderstandingExecution] = []
    
    private init() {
        // Initialize intent models inline for Swift 6 actor isolation
        let defaultPatterns: [IntentPattern] = [
            IntentPattern(keywords: ["create", "build", "make", "develop", "implement"], intentType: .create, confidence: 0.9),
            IntentPattern(keywords: ["analyze", "examine", "evaluate", "assess", "review"], intentType: .analyze, confidence: 0.9),
            IntentPattern(keywords: ["find", "search", "locate", "discover", "identify"], intentType: .search, confidence: 0.85),
            IntentPattern(keywords: ["update", "modify", "change", "edit", "revise"], intentType: .update, confidence: 0.85),
            IntentPattern(keywords: ["delete", "remove", "clear", "erase"], intentType: .delete, confidence: 0.9),
            IntentPattern(keywords: ["help", "assist", "support", "guide"], intentType: .help, confidence: 0.8)
        ]
        let technicalPatterns: [IntentPattern] = [
            IntentPattern(keywords: ["refactor", "optimize", "improve", "enhance"], intentType: .optimize, confidence: 0.9),
            IntentPattern(keywords: ["debug", "fix", "resolve", "troubleshoot"], intentType: .debug, confidence: 0.9),
            IntentPattern(keywords: ["deploy", "release", "publish", "ship"], intentType: .deploy, confidence: 0.85),
            IntentPattern(keywords: ["test", "verify", "validate", "check"], intentType: .test, confidence: 0.85)
        ]
        let businessPatterns: [IntentPattern] = [
            IntentPattern(keywords: ["plan", "strategy", "roadmap", "vision"], intentType: .plan, confidence: 0.85),
            IntentPattern(keywords: ["measure", "track", "monitor", "report"], intentType: .measure, confidence: 0.85),
            IntentPattern(keywords: ["decide", "choose", "select", "determine"], intentType: .decide, confidence: 0.8)
        ]
        
        intentModels = [
            "general": IntentModel(id: "general", patterns: defaultPatterns),
            "technical": IntentModel(id: "technical", patterns: technicalPatterns),
            "business": IntentModel(id: "business", patterns: businessPatterns)
        ]
    }
    
    // MARK: - Core Understanding
    
    /// Analyze any text input and extract structured meaning
    public func understand(_ input: String, context: UnderstandingContext = .init()) async -> UnderstandingResult {
        let cacheKey = "\(input.hashValue)_\(context.domain)"
        if let cached = analysisCache[cacheKey] { return cached }
        
        let start = Date()
        
        // Extract all components
        let intent = extractIntent(from: input, context: context)
        let entities = extractEntities(from: input)
        let constraints = extractConstraints(from: input)
        let risks = identifyRisks(from: input)
        let unknowns = mapUnknowns(from: input)
        let assumptions = detectAssumptions(from: input)
        let ambiguities = detectAmbiguities(from: input)
        let contradictions = detectContradictions(from: input, context: context)
        
        // Calculate confidence
        let confidence = calculateConfidence(
            intent: intent,
            entities: entities,
            ambiguities: ambiguities
        )
        
        let result = UnderstandingResult(
            input: input,
            intent: intent,
            entities: entities,
            constraints: constraints,
            risks: risks,
            unknowns: unknowns,
            assumptions: assumptions,
            ambiguities: ambiguities,
            contradictions: contradictions,
            confidence: confidence,
            processingTime: Date().timeIntervalSince(start)
        )
        
        analysisCache[cacheKey] = result
        executionLog.append(UnderstandingExecution(input: input, result: result, timestamp: Date()))
        
        return result
    }
    
    // MARK: - Intent Extraction
    
    /// Extract the core intent from text
    public func extractIntent(from text: String, context: UnderstandingContext = .init()) -> ExtractedIntent {
        let lowercased = text.lowercased()
        let model = intentModels[context.domain] ?? intentModels["general"]!
        
        var bestMatch: (pattern: IntentPattern, score: Float) = (IntentPattern(keywords: [], intentType: .unknown, confidence: 0), 0)
        
        for pattern in model.patterns {
            let score = calculatePatternMatch(text: lowercased, pattern: pattern)
            if score > bestMatch.score {
                bestMatch = (pattern, score)
            }
        }
        
        // Extract action and target
        let action = extractAction(from: text)
        let target = extractTarget(from: text)
        
        return ExtractedIntent(
            type: bestMatch.pattern.intentType,
            action: action,
            target: target,
            confidence: bestMatch.score,
            rawText: text
        )
    }
    
    // MARK: - Requirement Inference
    
    /// Infer missing requirements from partial specs
    public func inferRequirements(from text: String, existingRequirements: [String] = []) async -> InferredRequirements {
        let understood = await understand(text)
        
        var inferred: [InferredRequirement] = []
        var gaps: [RequirementGap] = []
        
        // Check for common missing requirements based on intent
        switch understood.intent.type {
        case .create, .build:
            if !text.lowercased().contains("error") && !text.lowercased().contains("exception") {
                gaps.append(RequirementGap(area: "Error Handling", description: "No error handling strategy specified", priority: .high))
            }
            if !text.lowercased().contains("test") {
                gaps.append(RequirementGap(area: "Testing", description: "No testing requirements specified", priority: .medium))
            }
            if !text.lowercased().contains("security") && !text.lowercased().contains("auth") {
                gaps.append(RequirementGap(area: "Security", description: "No security requirements specified", priority: .high))
            }
            
        case .analyze, .evaluate:
            if !text.lowercased().contains("metric") && !text.lowercased().contains("measure") {
                gaps.append(RequirementGap(area: "Metrics", description: "No success metrics defined", priority: .medium))
            }
            
        default:
            break
        }
        
        // Infer requirements from entities
        for entity in understood.entities {
            if entity.type == .technology {
                inferred.append(InferredRequirement(
                    requirement: "Integration with \(entity.value)",
                    source: "Entity extraction",
                    confidence: 0.7
                ))
            }
        }
        
        return InferredRequirements(
            explicit: existingRequirements,
            inferred: inferred,
            gaps: gaps,
            completenessScore: calculateCompleteness(explicit: existingRequirements, gaps: gaps)
        )
    }
    
    // MARK: - Ambiguity Detection
    
    /// Detect ambiguous sections in text
    public func detectAmbiguities(from text: String) -> [Ambiguity] {
        var ambiguities: [Ambiguity] = []
        let sentences = text.components(separatedBy: ". ")
        
        for (index, sentence) in sentences.enumerated() {
            let lowercased = sentence.lowercased()
            
            // Check for vague quantifiers
            let vagueQuantifiers = ["some", "many", "few", "several", "various", "multiple", "etc"]
            for quantifier in vagueQuantifiers {
                if lowercased.contains(quantifier) {
                    ambiguities.append(Ambiguity(
                        text: sentence,
                        type: .vagueQuantifier,
                        location: index,
                        suggestion: "Specify exact quantity or range",
                        severity: .medium
                    ))
                }
            }
            
            // Check for unclear references
            let unclearRefs = ["it", "this", "that", "they", "those"]
            for ref in unclearRefs where lowercased.hasPrefix(ref + " ") {
                ambiguities.append(Ambiguity(
                    text: sentence,
                    type: .unclearReference,
                    location: index,
                    suggestion: "Clarify what '\(ref)' refers to",
                    severity: .high
                ))
            }
            
            // Check for passive voice (often hides responsibility)
            if lowercased.contains("should be") || lowercased.contains("will be") || lowercased.contains("can be") {
                ambiguities.append(Ambiguity(
                    text: sentence,
                    type: .passiveVoice,
                    location: index,
                    suggestion: "Specify who/what performs the action",
                    severity: .low
                ))
            }
        }
        
        return ambiguities
    }
    
    // MARK: - Assumption Detection
    
    /// Detect hidden assumptions in text
    public func detectAssumptions(from text: String) -> [Assumption] {
        var assumptions: [Assumption] = []
        let lowercased = text.lowercased()
        
        // Technical assumptions
        if lowercased.contains("api") && !lowercased.contains("rate limit") {
            assumptions.append(Assumption(
                assumption: "API has no rate limits",
                category: .technical,
                risk: .medium,
                validationSuggestion: "Verify API rate limits and implement throttling"
            ))
        }
        
        if lowercased.contains("database") && !lowercased.contains("scale") && !lowercased.contains("performance") {
            assumptions.append(Assumption(
                assumption: "Database will handle expected load",
                category: .technical,
                risk: .high,
                validationSuggestion: "Define expected data volume and query patterns"
            ))
        }
        
        // Business assumptions
        if lowercased.contains("user") && !lowercased.contains("how many") && !lowercased.contains("number of") {
            assumptions.append(Assumption(
                assumption: "User volume is manageable",
                category: .business,
                risk: .medium,
                validationSuggestion: "Define expected user count and growth rate"
            ))
        }
        
        // Timeline assumptions
        if lowercased.contains("quick") || lowercased.contains("fast") || lowercased.contains("simple") {
            assumptions.append(Assumption(
                assumption: "Implementation will be straightforward",
                category: .timeline,
                risk: .high,
                validationSuggestion: "Break down into specific tasks with estimates"
            ))
        }
        
        return assumptions
    }
    
    // MARK: - Contradiction Detection
    
    /// Detect contradictions within text or against context
    public func detectContradictions(from text: String, context: UnderstandingContext = .init()) -> [Contradiction] {
        var contradictions: [Contradiction] = []
        let sentences = text.components(separatedBy: ". ")
        
        // Check for internal contradictions
        for i in 0..<sentences.count {
            for j in (i+1)..<sentences.count {
                if let contradiction = findContradiction(sentences[i], sentences[j]) {
                    contradictions.append(contradiction)
                }
            }
        }
        
        // Check against context
        for statement in context.previousStatements {
            if let contradiction = findContradiction(text, statement) {
                contradictions.append(contradiction)
            }
        }
        
        return contradictions
    }
    
    // MARK: - Private Helpers
    
    private func extractEntities(from text: String) -> [Entity] {
        var entities: [Entity] = []
        let words = text.components(separatedBy: .whitespaces)
        
        // Technology detection
        let technologies = ["swift", "python", "javascript", "api", "database", "ml", "ai", "cloud", "aws", "ios", "macos"]
        for tech in technologies where text.lowercased().contains(tech) {
            entities.append(Entity(value: tech, type: .technology, confidence: 0.9))
        }
        
        // Action detection
        let actions = ["create", "build", "analyze", "generate", "convert", "track", "manage"]
        for action in actions where text.lowercased().contains(action) {
            entities.append(Entity(value: action, type: .action, confidence: 0.85))
        }
        
        return entities
    }
    
    private func extractConstraints(from text: String) -> [Constraint] {
        var constraints: [Constraint] = []
        let lowercased = text.lowercased()
        
        // Time constraints
        if lowercased.contains("deadline") || lowercased.contains("by ") || lowercased.contains("within") {
            constraints.append(Constraint(type: .time, description: "Time-bound delivery", severity: .hard))
        }
        
        // Resource constraints
        if lowercased.contains("budget") || lowercased.contains("cost") || lowercased.contains("limited") {
            constraints.append(Constraint(type: .resource, description: "Resource limitations", severity: .hard))
        }
        
        // Technical constraints
        if lowercased.contains("must use") || lowercased.contains("required") || lowercased.contains("only") {
            constraints.append(Constraint(type: .technical, description: "Technical requirements", severity: .hard))
        }
        
        return constraints
    }
    
    private func identifyRisks(from text: String) -> [Risk] {
        var risks: [Risk] = []
        let lowercased = text.lowercased()
        
        // Complexity risks
        if lowercased.contains("complex") || lowercased.contains("advanced") || lowercased.contains("sophisticated") {
            risks.append(Risk(
                description: "High complexity may lead to delays",
                category: .technical,
                likelihood: .medium,
                impact: .high
            ))
        }
        
        // Dependency risks
        if lowercased.contains("depend") || lowercased.contains("integration") || lowercased.contains("third-party") {
            risks.append(Risk(
                description: "External dependencies may cause blockers",
                category: .dependency,
                likelihood: .medium,
                impact: .medium
            ))
        }
        
        return risks
    }
    
    private func mapUnknowns(from text: String) -> [Unknown] {
        var unknowns: [Unknown] = []
        let lowercased = text.lowercased()
        
        // Question marks indicate unknowns
        if text.contains("?") {
            unknowns.append(Unknown(area: "Open Questions", description: "Explicit questions need answers", priority: .high))
        }
        
        // Uncertainty language
        let uncertainWords = ["maybe", "perhaps", "might", "could", "possibly", "unclear"]
        for word in uncertainWords where lowercased.contains(word) {
            unknowns.append(Unknown(area: "Uncertainty", description: "Decision pending: contains '\(word)'", priority: .medium))
        }
        
        return unknowns
    }
    
    private func extractAction(from text: String) -> String {
        let actionVerbs = ["create", "build", "analyze", "generate", "convert", "track", "manage", "design", "implement", "develop"]
        for verb in actionVerbs where text.lowercased().contains(verb) {
            return verb
        }
        return "process"
    }
    
    private func extractTarget(from text: String) -> String {
        let targets = ["app", "system", "tool", "service", "api", "platform", "engine", "module", "package"]
        for target in targets where text.lowercased().contains(target) {
            return target
        }
        return "solution"
    }
    
    private func calculatePatternMatch(text: String, pattern: IntentPattern) -> Float {
        var matches = 0
        for keyword in pattern.keywords where text.contains(keyword) {
            matches += 1
        }
        return pattern.keywords.isEmpty ? 0 : Float(matches) / Float(pattern.keywords.count) * pattern.confidence
    }
    
    private func calculateConfidence(intent: ExtractedIntent, entities: [Entity], ambiguities: [Ambiguity]) -> Float {
        var confidence = intent.confidence
        confidence += Float(entities.count) * 0.05
        confidence -= Float(ambiguities.count) * 0.1
        return max(0, min(1, confidence))
    }
    
    private func calculateCompleteness(explicit: [String], gaps: [RequirementGap]) -> Float {
        let total = Float(explicit.count + gaps.count)
        return total > 0 ? Float(explicit.count) / total : 0
    }
    
    private func findContradiction(_ text1: String, _ text2: String) -> Contradiction? {
        let l1 = text1.lowercased()
        let l2 = text2.lowercased()
        
        // Simple contradiction patterns
        let contradictionPairs = [
            ("always", "never"), ("all", "none"), ("must", "must not"),
            ("required", "optional"), ("simple", "complex"), ("fast", "slow")
        ]
        
        for (word1, word2) in contradictionPairs {
            if (l1.contains(word1) && l2.contains(word2)) || (l1.contains(word2) && l2.contains(word1)) {
                return Contradiction(
                    statement1: text1,
                    statement2: text2,
                    conflictType: .logical,
                    resolution: "Clarify which statement takes precedence"
                )
            }
        }
        
        return nil
    }
    
    // MARK: - Stats
    
    public var stats: UnderstandingStats {
        UnderstandingStats(
            totalAnalyses: executionLog.count,
            cacheHitRate: Float(analysisCache.count) / Float(max(1, executionLog.count)),
            averageConfidence: executionLog.isEmpty ? 0 : executionLog.reduce(0) { $0 + $1.result.confidence } / Float(executionLog.count),
            modelCount: intentModels.count
        )
    }
}
