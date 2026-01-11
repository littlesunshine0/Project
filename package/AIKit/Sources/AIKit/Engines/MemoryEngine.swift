//
//  MemoryEngine.swift
//  AIKit - Core Intelligence Engine #4
//
//  Purpose: Maintain long-term, evolving intelligence
//  Capabilities: Semantic project memory, context compression,
//                knowledge decay prediction, doc-code alignment,
//                change significance detection
//

import Foundation

// MARK: - Knowledge & Memory Engine

/// Core Engine #4: Maintains long-term, evolving intelligence
public actor MemoryEngine {
    public static let shared = MemoryEngine()
    
    private var projectMemories: [String: ProjectMemory] = [:]
    private var knowledgeGraph: KnowledgeGraph = KnowledgeGraph()
    private var changeHistory: [ChangeEvent] = []
    private var compressionCache: [String: CompressedContext] = [:]
    private var executionLog: [MemoryExecution] = []
    
    private init() {}
    
    // MARK: - Semantic Project Memory
    
    /// Store semantic memory for a project
    public func remember(projectId: String, content: MemoryContent) async {
        var memory = projectMemories[projectId] ?? ProjectMemory(projectId: projectId)
        
        // Extract semantic meaning
        let semantics = extractSemantics(from: content)
        
        // Calculate importance
        let importance = calculateImportance(content: content, semantics: semantics)
        
        // Store with decay tracking
        let entry = MemoryEntry(
            id: UUID().uuidString,
            content: content,
            semantics: semantics,
            importance: importance,
            createdAt: Date(),
            lastAccessed: Date(),
            accessCount: 0,
            decayFactor: 1.0
        )
        
        memory.entries.append(entry)
        
        // Update knowledge graph
        updateKnowledgeGraph(entry: entry, projectId: projectId)
        
        projectMemories[projectId] = memory
        executionLog.append(MemoryExecution(type: .store, timestamp: Date()))
    }
    
    /// Recall relevant memories for a query
    public func recall(projectId: String, query: String, limit: Int = 10) async -> [RecalledMemory] {
        guard let memory = projectMemories[projectId] else { return [] }
        
        // Score entries by relevance
        var scored: [(entry: MemoryEntry, score: Float)] = []
        
        for entry in memory.entries {
            let relevance = calculateRelevance(entry: entry, query: query)
            let recency = calculateRecency(entry: entry)
            let importance = entry.importance
            
            // Combined score with decay
            let score = (relevance * 0.5 + recency * 0.2 + importance * 0.3) * entry.decayFactor
            scored.append((entry, score))
        }
        
        // Sort and limit
        let topEntries = scored.sorted { $0.score > $1.score }.prefix(limit)
        
        // Update access tracking
        for (entry, _) in topEntries {
            await updateAccessTracking(projectId: projectId, entryId: entry.id)
        }
        
        return topEntries.map { RecalledMemory(entry: $0.entry, relevanceScore: $0.score) }
    }
    
    /// Get what matters long-term vs noise
    public func getSignificantMemories(projectId: String) async -> [MemoryEntry] {
        guard let memory = projectMemories[projectId] else { return [] }
        
        // Filter by importance and access patterns
        return memory.entries.filter { entry in
            entry.importance > 0.6 || entry.accessCount > 3
        }.sorted { $0.importance > $1.importance }
    }
    
    // MARK: - Context Compression
    
    /// Compress conversation/history into retrievable knowledge
    public func compressContext(_ context: ContextInput) async -> CompressedContext {
        let cacheKey = context.id
        if let cached = compressionCache[cacheKey] { return cached }
        
        let start = Date()
        
        // Extract key points
        let keyPoints = extractKeyPoints(from: context.content)
        
        // Identify decisions made
        let decisions = extractDecisions(from: context.content)
        
        // Extract action items
        let actionItems = extractActionItems(from: context.content)
        
        // Generate summary
        let summary = generateSummary(keyPoints: keyPoints, decisions: decisions)
        
        // Create compressed representation
        let compressed = CompressedContext(
            id: context.id,
            originalLength: context.content.count,
            compressedLength: summary.count,
            compressionRatio: Float(summary.count) / Float(max(1, context.content.count)),
            summary: summary,
            keyPoints: keyPoints,
            decisions: decisions,
            actionItems: actionItems,
            entities: extractEntitiesFromContext(context.content),
            timestamp: Date(),
            processingTime: Date().timeIntervalSince(start)
        )
        
        compressionCache[cacheKey] = compressed
        executionLog.append(MemoryExecution(type: .compress, timestamp: Date()))
        
        return compressed
    }
    
    // MARK: - Knowledge Decay Prediction
    
    /// Predict which knowledge is becoming outdated
    public func predictDecay(projectId: String) async -> DecayPrediction {
        guard let memory = projectMemories[projectId] else {
            return DecayPrediction(projectId: projectId, atRiskEntries: [], recommendations: [])
        }
        
        var atRisk: [DecayRiskEntry] = []
        let now = Date()
        
        for entry in memory.entries {
            let daysSinceCreated = now.timeIntervalSince(entry.createdAt) / 86400
            let daysSinceAccessed = now.timeIntervalSince(entry.lastAccessed) / 86400
            
            // Calculate decay risk
            var decayRisk: Float = 0
            
            // Time-based decay
            if daysSinceAccessed > 30 { decayRisk += 0.3 }
            if daysSinceAccessed > 90 { decayRisk += 0.3 }
            
            // Content type decay (code references decay faster)
            if entry.content.type == .codeReference { decayRisk += 0.2 }
            
            // Low access count
            if entry.accessCount < 2 && daysSinceCreated > 14 { decayRisk += 0.2 }
            
            if decayRisk > 0.5 {
                atRisk.append(DecayRiskEntry(
                    entryId: entry.id,
                    content: entry.content.summary,
                    decayRisk: min(1.0, decayRisk),
                    daysSinceAccessed: Int(daysSinceAccessed),
                    recommendation: generateDecayRecommendation(entry: entry, risk: decayRisk)
                ))
            }
        }
        
        return DecayPrediction(
            projectId: projectId,
            atRiskEntries: atRisk.sorted { $0.decayRisk > $1.decayRisk },
            recommendations: generateOverallDecayRecommendations(atRisk: atRisk)
        )
    }
    
    /// Apply decay to memories (call periodically)
    public func applyDecay(projectId: String) async {
        guard var memory = projectMemories[projectId] else { return }
        
        let now = Date()
        for i in 0..<memory.entries.count {
            let daysSinceAccessed = now.timeIntervalSince(memory.entries[i].lastAccessed) / 86400
            
            // Exponential decay based on time and importance
            let baseDecay = pow(0.99, Float(daysSinceAccessed))
            let importanceBoost = memory.entries[i].importance * 0.2
            memory.entries[i].decayFactor = min(1.0, baseDecay + importanceBoost)
        }
        
        projectMemories[projectId] = memory
    }
    
    // MARK: - Doc-Code Alignment
    
    /// Detect if documentation still matches code
    public func checkDocCodeAlignment(doc: DocumentInfo, code: CodeInfo) async -> AlignmentAnalysis {
        let start = Date()
        
        // Extract concepts from doc
        let docConcepts = extractConcepts(from: doc.content)
        
        // Extract concepts from code
        let codeConcepts = extractConcepts(from: code.content)
        
        // Find mismatches
        let missingInDoc = codeConcepts.filter { !docConcepts.contains($0) }
        let extraInDoc = docConcepts.filter { !codeConcepts.contains($0) }
        
        // Calculate alignment score
        let totalConcepts = Set(docConcepts + codeConcepts).count
        let matchedConcepts = totalConcepts - missingInDoc.count - extraInDoc.count
        let alignmentScore = Float(matchedConcepts) / Float(max(1, totalConcepts))
        
        // Detect drift
        let driftLevel: DriftLevel
        switch alignmentScore {
        case 0.9...: driftLevel = .none
        case 0.7..<0.9: driftLevel = .minor
        case 0.5..<0.7: driftLevel = .moderate
        default: driftLevel = .severe
        }
        
        return AlignmentAnalysis(
            docPath: doc.path,
            codePath: code.path,
            alignmentScore: alignmentScore,
            driftLevel: driftLevel,
            missingInDoc: missingInDoc,
            extraInDoc: extraInDoc,
            suggestions: generateAlignmentSuggestions(missing: missingInDoc, extra: extraInDoc),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Change Significance Detection
    
    /// Detect if a change is significant or noise
    public func assessChangeSignificance(change: ChangeInput) async -> ChangeSignificance {
        let start = Date()
        
        // Analyze change characteristics
        let linesChanged = change.additions + change.deletions
        let isStructural = detectStructuralChange(change: change)
        let affectsPublicAPI = detectPublicAPIChange(change: change)
        let isRefactoring = detectRefactoring(change: change)
        
        // Calculate significance score
        var significance: Float = 0.3
        
        if linesChanged > 100 { significance += 0.2 }
        if isStructural { significance += 0.25 }
        if affectsPublicAPI { significance += 0.3 }
        if isRefactoring { significance -= 0.1 } // Refactoring is often less significant
        
        // Determine category
        let category: ChangeCategory
        if affectsPublicAPI { category = .breaking }
        else if isStructural { category = .structural }
        else if isRefactoring { category = .refactoring }
        else if linesChanged < 10 { category = .trivial }
        else { category = .feature }
        
        // Record for learning
        changeHistory.append(ChangeEvent(change: change, significance: significance, timestamp: Date()))
        
        return ChangeSignificance(
            changeId: change.id,
            significanceScore: min(1.0, significance),
            category: category,
            isSignificant: significance > 0.5,
            reasoning: generateSignificanceReasoning(
                linesChanged: linesChanged,
                isStructural: isStructural,
                affectsPublicAPI: affectsPublicAPI
            ),
            recommendations: generateChangeRecommendations(category: category, significance: significance),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Cross-Domain Insight
    
    /// Find patterns that transfer across domains/projects
    public func findCrossDomainInsights(projectIds: [String]) async -> [CrossDomainInsight] {
        var insights: [CrossDomainInsight] = []
        
        // Collect all memories
        var allEntries: [(projectId: String, entry: MemoryEntry)] = []
        for projectId in projectIds {
            if let memory = projectMemories[projectId] {
                for entry in memory.entries {
                    allEntries.append((projectId, entry))
                }
            }
        }
        
        // Find common patterns
        let patterns = findCommonPatterns(entries: allEntries)
        
        for pattern in patterns {
            insights.append(CrossDomainInsight(
                pattern: pattern.description,
                foundInProjects: pattern.projectIds,
                applicability: pattern.applicability,
                recommendation: "Consider applying this pattern: \(pattern.description)"
            ))
        }
        
        return insights
    }
    
    // MARK: - Private Helpers
    
    private func extractSemantics(from content: MemoryContent) -> SemanticInfo {
        let keywords = extractKeywords(from: content.summary)
        let topics = inferTopics(from: content.summary)
        let sentiment = analyzeSentiment(content.summary)
        
        return SemanticInfo(keywords: keywords, topics: topics, sentiment: sentiment)
    }
    
    private func extractKeywords(from text: String) -> [String] {
        let words = text.lowercased().components(separatedBy: .whitespaces)
        let stopWords = Set(["the", "a", "an", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "do", "does", "did", "will", "would", "could", "should", "may", "might", "must", "shall", "can", "need", "dare", "ought", "used", "to", "of", "in", "for", "on", "with", "at", "by", "from", "as", "into", "through", "during", "before", "after", "above", "below", "between", "under", "again", "further", "then", "once", "and", "but", "or", "nor", "so", "yet", "both", "either", "neither", "not", "only", "own", "same", "than", "too", "very", "just"])
        return words.filter { $0.count > 3 && !stopWords.contains($0) }
    }
    
    private func inferTopics(from text: String) -> [String] {
        var topics: [String] = []
        let lowercased = text.lowercased()
        
        let topicKeywords: [String: [String]] = [
            "architecture": ["architecture", "design", "pattern", "structure"],
            "testing": ["test", "testing", "spec", "coverage"],
            "performance": ["performance", "speed", "optimize", "fast"],
            "security": ["security", "auth", "permission", "encrypt"],
            "api": ["api", "endpoint", "rest", "graphql"],
            "database": ["database", "query", "sql", "storage"]
        ]
        
        for (topic, keywords) in topicKeywords {
            if keywords.contains(where: { lowercased.contains($0) }) {
                topics.append(topic)
            }
        }
        
        return topics
    }
    
    private func analyzeSentiment(_ text: String) -> Float {
        let positive = ["good", "great", "excellent", "success", "working", "complete", "done"]
        let negative = ["bad", "fail", "error", "bug", "issue", "problem", "broken"]
        
        let lowercased = text.lowercased()
        var score: Float = 0.5
        
        for word in positive where lowercased.contains(word) { score += 0.1 }
        for word in negative where lowercased.contains(word) { score -= 0.1 }
        
        return max(0, min(1, score))
    }
    
    private func calculateImportance(content: MemoryContent, semantics: SemanticInfo) -> Float {
        var importance: Float = 0.5
        
        // More keywords = more important
        importance += Float(semantics.keywords.count) * 0.02
        
        // Certain topics are more important
        if semantics.topics.contains("architecture") { importance += 0.15 }
        if semantics.topics.contains("security") { importance += 0.15 }
        
        // Content type importance
        switch content.type {
        case .decision: importance += 0.2
        case .architecture: importance += 0.2
        case .requirement: importance += 0.15
        case .codeReference: importance += 0.05
        case .note: importance += 0.0
        }
        
        return min(1.0, importance)
    }
    
    private func calculateRelevance(entry: MemoryEntry, query: String) -> Float {
        let queryKeywords = Set(extractKeywords(from: query))
        let entryKeywords = Set(entry.semantics.keywords)
        
        let intersection = queryKeywords.intersection(entryKeywords)
        let union = queryKeywords.union(entryKeywords)
        
        return union.isEmpty ? 0 : Float(intersection.count) / Float(union.count)
    }
    
    private func calculateRecency(entry: MemoryEntry) -> Float {
        let daysSince = Date().timeIntervalSince(entry.lastAccessed) / 86400
        return max(0, 1.0 - Float(daysSince) / 90.0)
    }
    
    private func updateAccessTracking(projectId: String, entryId: String) async {
        guard var memory = projectMemories[projectId] else { return }
        if let index = memory.entries.firstIndex(where: { $0.id == entryId }) {
            memory.entries[index].lastAccessed = Date()
            memory.entries[index].accessCount += 1
            projectMemories[projectId] = memory
        }
    }
    
    private func updateKnowledgeGraph(entry: MemoryEntry, projectId: String) {
        // Add nodes for keywords
        for keyword in entry.semantics.keywords {
            knowledgeGraph.addNode(KnowledgeNode(id: keyword, type: .concept, projectId: projectId))
        }
        
        // Add edges between related keywords
        let keywords = entry.semantics.keywords
        for i in 0..<keywords.count {
            for j in (i+1)..<keywords.count {
                knowledgeGraph.addEdge(from: keywords[i], to: keywords[j], weight: 1.0)
            }
        }
    }
    
    private func extractKeyPoints(from content: String) -> [String] {
        let sentences = content.components(separatedBy: ". ")
        return sentences.filter { sentence in
            let lowercased = sentence.lowercased()
            return lowercased.contains("important") ||
                   lowercased.contains("key") ||
                   lowercased.contains("must") ||
                   lowercased.contains("should") ||
                   lowercased.contains("decision")
        }.prefix(5).map { String($0) }
    }
    
    private func extractDecisions(from content: String) -> [String] {
        let sentences = content.components(separatedBy: ". ")
        return sentences.filter { sentence in
            let lowercased = sentence.lowercased()
            return lowercased.contains("decided") ||
                   lowercased.contains("will use") ||
                   lowercased.contains("chose") ||
                   lowercased.contains("going with")
        }.map { String($0) }
    }
    
    private func extractActionItems(from content: String) -> [String] {
        let sentences = content.components(separatedBy: ". ")
        return sentences.filter { sentence in
            let lowercased = sentence.lowercased()
            return lowercased.contains("todo") ||
                   lowercased.contains("action") ||
                   lowercased.contains("need to") ||
                   lowercased.contains("will ")
        }.map { String($0) }
    }
    
    private func generateSummary(keyPoints: [String], decisions: [String]) -> String {
        var summary = ""
        if !keyPoints.isEmpty {
            summary += "Key points: " + keyPoints.prefix(3).joined(separator: "; ")
        }
        if !decisions.isEmpty {
            summary += " Decisions: " + decisions.prefix(2).joined(separator: "; ")
        }
        return summary.isEmpty ? "No significant content extracted" : summary
    }
    
    private func extractEntitiesFromContext(_ content: String) -> [String] {
        extractKeywords(from: content).prefix(10).map { String($0) }
    }
    
    private func generateDecayRecommendation(entry: MemoryEntry, risk: Float) -> String {
        if risk > 0.8 { return "Review and update or archive this knowledge" }
        if risk > 0.6 { return "Consider refreshing this information" }
        return "Monitor for continued relevance"
    }
    
    private func generateOverallDecayRecommendations(atRisk: [DecayRiskEntry]) -> [String] {
        var recommendations: [String] = []
        if atRisk.count > 5 {
            recommendations.append("Consider a knowledge audit - \(atRisk.count) entries at risk of decay")
        }
        if atRisk.contains(where: { $0.decayRisk > 0.8 }) {
            recommendations.append("Some critical knowledge may be outdated - review high-risk entries")
        }
        return recommendations
    }
    
    private func extractConcepts(from text: String) -> [String] {
        extractKeywords(from: text)
    }
    
    private func generateAlignmentSuggestions(missing: [String], extra: [String]) -> [String] {
        var suggestions: [String] = []
        if !missing.isEmpty {
            suggestions.append("Add documentation for: \(missing.prefix(5).joined(separator: ", "))")
        }
        if !extra.isEmpty {
            suggestions.append("Remove or update outdated references: \(extra.prefix(5).joined(separator: ", "))")
        }
        return suggestions
    }
    
    private func detectStructuralChange(change: ChangeInput) -> Bool {
        let structuralKeywords = ["class", "struct", "protocol", "interface", "module", "package"]
        return structuralKeywords.contains { change.description.lowercased().contains($0) }
    }
    
    private func detectPublicAPIChange(change: ChangeInput) -> Bool {
        let apiKeywords = ["public", "api", "endpoint", "interface", "protocol"]
        return apiKeywords.contains { change.description.lowercased().contains($0) }
    }
    
    private func detectRefactoring(change: ChangeInput) -> Bool {
        let refactorKeywords = ["refactor", "rename", "move", "extract", "cleanup"]
        return refactorKeywords.contains { change.description.lowercased().contains($0) }
    }
    
    private func generateSignificanceReasoning(linesChanged: Int, isStructural: Bool, affectsPublicAPI: Bool) -> String {
        var reasons: [String] = []
        if linesChanged > 100 { reasons.append("Large change (\(linesChanged) lines)") }
        if isStructural { reasons.append("Structural modification") }
        if affectsPublicAPI { reasons.append("Affects public API") }
        return reasons.isEmpty ? "Minor change" : reasons.joined(separator: ", ")
    }
    
    private func generateChangeRecommendations(category: ChangeCategory, significance: Float) -> [String] {
        switch category {
        case .breaking: return ["Update documentation", "Notify dependent teams", "Add migration guide"]
        case .structural: return ["Review architecture impact", "Update diagrams"]
        case .feature: return ["Add tests", "Update changelog"]
        case .refactoring: return ["Verify behavior unchanged", "Run full test suite"]
        case .trivial: return []
        }
    }
    
    private func findCommonPatterns(entries: [(projectId: String, entry: MemoryEntry)]) -> [CommonPattern] {
        // Simplified pattern detection
        var keywordCounts: [String: Set<String>] = [:]
        
        for (projectId, entry) in entries {
            for keyword in entry.semantics.keywords {
                keywordCounts[keyword, default: []].insert(projectId)
            }
        }
        
        return keywordCounts.filter { $0.value.count > 1 }.map { keyword, projects in
            CommonPattern(
                description: "Common use of '\(keyword)'",
                projectIds: Array(projects),
                applicability: Float(projects.count) / Float(max(1, Set(entries.map { $0.projectId }).count))
            )
        }
    }
    
    // MARK: - Stats
    
    public var stats: MemoryStats {
        let totalEntries = projectMemories.values.reduce(0) { $0 + $1.entries.count }
        return MemoryStats(
            projectCount: projectMemories.count,
            totalEntries: totalEntries,
            compressionCacheSize: compressionCache.count,
            changeHistorySize: changeHistory.count
        )
    }
}
