//
//  DecisionLog.swift
//  IdeaKit - Project Operating System
//
//  Tool: DecisionLog
//  Phase: Documentation
//  Purpose: Record "why" behind choices - ADR style
//  Outputs: decisions.md
//

import Foundation

/// Records architectural and design decisions
public final class DecisionLog: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "decision_log"
    public static let name = "Decision Log"
    public static let description = "Record architecture decisions, tradeoffs, and rejected alternatives (ADR style)"
    public static let phase = ProjectPhase.documentation
    public static let outputs = ["decisions.md"]
    public static let inputs: [String] = []
    public static let isDefault = false
    
    // MARK: - Singleton
    
    public static let shared = DecisionLog()
    private init() {}
    
    // MARK: - State
    
    private var records: [ADR] = []
    
    // MARK: - Recording
    
    /// Record a new decision
    public func record(_ adr: ADR) {
        records.append(adr)
    }
    
    /// Get all decisions
    public func allDecisions() -> [ADR] {
        records
    }
    
    /// Get decisions by status
    public func decisions(status: ADRStatus) -> [ADR] {
        records.filter { $0.status == status }
    }
    
    // MARK: - Generation
    
    /// Generate decisions markdown
    public func generateMarkdown() -> String {
        var md = """
        # Architecture Decision Records
        
        ## Summary
        
        | # | Title | Status | Date |
        |---|-------|--------|------|
        """
        
        for (index, adr) in records.enumerated() {
            let statusEmoji = statusEmoji(adr.status)
            md += "\n| \(index + 1) | \(adr.title) | \(statusEmoji) \(adr.status.rawValue) | \(formatDate(adr.date)) |"
        }
        
        md += "\n\n---\n"
        
        for (index, adr) in records.enumerated() {
            md += """
            
            ## ADR-\(String(format: "%03d", index + 1)): \(adr.title)
            
            **Status**: \(adr.status.rawValue.capitalized)
            **Date**: \(formatDate(adr.date))
            **Deciders**: \(adr.deciders.joined(separator: ", "))
            
            ### Context
            
            \(adr.context)
            
            ### Decision
            
            \(adr.decision)
            
            ### Consequences
            
            **Positive**:
            \(adr.positiveConsequences.map { "- \($0)" }.joined(separator: "\n"))
            
            **Negative**:
            \(adr.negativeConsequences.map { "- \($0)" }.joined(separator: "\n"))
            
            ### Alternatives Considered
            
            \(adr.alternatives.map { alt in
                """
                #### \(alt.name)
                
                \(alt.description)
                
                **Rejected because**: \(alt.rejectionReason)
                """
            }.joined(separator: "\n\n"))
            
            ---
            
            """
        }
        
        return md
    }
    
    /// Generate single ADR markdown
    public func generateADRMarkdown(_ adr: ADR, number: Int) -> String {
        """
        # ADR-\(String(format: "%03d", number)): \(adr.title)
        
        ## Status
        
        \(adr.status.rawValue.capitalized)
        
        ## Context
        
        \(adr.context)
        
        ## Decision
        
        \(adr.decision)
        
        ## Consequences
        
        ### Positive
        
        \(adr.positiveConsequences.map { "- \($0)" }.joined(separator: "\n"))
        
        ### Negative
        
        \(adr.negativeConsequences.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Alternatives Considered
        
        \(adr.alternatives.enumerated().map { index, alt in
            """
            ### \(index + 1). \(alt.name)
            
            \(alt.description)
            
            **Rejected because**: \(alt.rejectionReason)
            """
        }.joined(separator: "\n\n"))
        """
    }
    
    // MARK: - Private Helpers
    
    private func statusEmoji(_ status: ADRStatus) -> String {
        switch status {
        case .proposed: return "📝"
        case .accepted: return "✅"
        case .deprecated: return "⚠️"
        case .superseded: return "🔄"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Types

public struct ADR: Sendable, Identifiable {
    public var id: UUID
    public var title: String
    public var status: ADRStatus
    public var date: Date
    public var deciders: [String]
    public var context: String
    public var decision: String
    public var positiveConsequences: [String]
    public var negativeConsequences: [String]
    public var alternatives: [Alternative]
    
    public init(
        id: UUID = UUID(),
        title: String,
        status: ADRStatus = .proposed,
        date: Date = Date(),
        deciders: [String] = [],
        context: String,
        decision: String,
        positiveConsequences: [String] = [],
        negativeConsequences: [String] = [],
        alternatives: [Alternative] = []
    ) {
        self.id = id
        self.title = title
        self.status = status
        self.date = date
        self.deciders = deciders
        self.context = context
        self.decision = decision
        self.positiveConsequences = positiveConsequences
        self.negativeConsequences = negativeConsequences
        self.alternatives = alternatives
    }
}

public enum ADRStatus: String, Sendable {
    case proposed, accepted, deprecated, superseded
}

public struct Alternative: Sendable {
    public let name: String
    public let description: String
    public let rejectionReason: String
    
    public init(name: String, description: String, rejectionReason: String) {
        self.name = name
        self.description = description
        self.rejectionReason = rejectionReason
    }
}
