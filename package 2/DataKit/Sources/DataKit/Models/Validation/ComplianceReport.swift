//
//  ComplianceReport.swift
//  DataKit
//

import Foundation

/// Package compliance report
public struct ComplianceReport: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let packageId: String
    public let version: String
    public let results: [ValidationResult]
    public let coverage: CoverageModel?
    public let qualityGates: [QualityGate]
    public let isCompliant: Bool
    public let score: Double
    public let generatedAt: Date
    
    public init(id: String = UUID().uuidString, packageId: String, version: String, results: [ValidationResult], coverage: CoverageModel? = nil, qualityGates: [QualityGate] = []) {
        self.id = id
        self.packageId = packageId
        self.version = version
        self.results = results
        self.coverage = coverage
        self.qualityGates = qualityGates
        self.isCompliant = results.allSatisfy { $0.passed } && qualityGates.allSatisfy { $0.passed }
        self.score = results.isEmpty ? 0 : Double(results.filter { $0.passed }.count) / Double(results.count) * 100
        self.generatedAt = Date()
    }
    
    public var passedCount: Int { results.filter { $0.passed }.count }
    public var failedCount: Int { results.filter { !$0.passed }.count }
}
