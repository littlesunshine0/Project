//
//  CoverageModel.swift
//  DataKit
//

import Foundation

/// Code/test coverage model
public struct CoverageModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let packageId: String
    public let linesCovered: Int
    public let linesTotal: Int
    public let branchesCovered: Int
    public let branchesTotal: Int
    public let functionsCovered: Int
    public let functionsTotal: Int
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, packageId: String, linesCovered: Int, linesTotal: Int, branchesCovered: Int = 0, branchesTotal: Int = 0, functionsCovered: Int = 0, functionsTotal: Int = 0) {
        self.id = id
        self.packageId = packageId
        self.linesCovered = linesCovered
        self.linesTotal = linesTotal
        self.branchesCovered = branchesCovered
        self.branchesTotal = branchesTotal
        self.functionsCovered = functionsCovered
        self.functionsTotal = functionsTotal
        self.timestamp = Date()
    }
    
    public var linePercentage: Double {
        guard linesTotal > 0 else { return 0 }
        return Double(linesCovered) / Double(linesTotal) * 100
    }
    
    public var branchPercentage: Double {
        guard branchesTotal > 0 else { return 0 }
        return Double(branchesCovered) / Double(branchesTotal) * 100
    }
}
