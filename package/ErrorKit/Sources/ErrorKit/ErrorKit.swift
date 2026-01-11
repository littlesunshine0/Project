//
//  ErrorKit.swift
//  ErrorKit
//
//  Error handling, recovery, and reporting
//

import Foundation

public struct ErrorKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.errorkit"
    public init() {}
}

// MARK: - Error Recovery Engine

public actor ErrorRecoveryEngine {
    public static let shared = ErrorRecoveryEngine()
    
    private var errors: [UUID: RecordedError] = [:]
    private var recoveryStrategies: [String: RecoveryStrategy] = [
        "retry": RecoveryStrategy(id: "retry", name: "Retry", action: .retry(maxAttempts: 3)),
        "ignore": RecoveryStrategy(id: "ignore", name: "Ignore", action: .ignore),
        "fallback": RecoveryStrategy(id: "fallback", name: "Fallback", action: .fallback)
    ]
    private var errorPatterns: [String: Int] = [:]  // pattern -> count
    
    private init() {}
    
    public func record(_ error: RecordedError) -> UUID {
        errors[error.id] = error
        errorPatterns[error.code, default: 0] += 1
        return error.id
    }
    
    public func record(code: String, message: String, severity: ErrorSeverity = .error, context: [String: String] = [:]) -> UUID {
        let error = RecordedError(code: code, message: message, severity: severity, context: context)
        return record(error)
    }
    
    public func getError(_ id: UUID) -> RecordedError? { errors[id] }
    public func getAll() -> [RecordedError] { Array(errors.values) }
    
    public func getBySeverity(_ severity: ErrorSeverity) -> [RecordedError] {
        errors.values.filter { $0.severity == severity }
    }
    
    public func suggestRecovery(for errorCode: String) -> RecoveryStrategy? {
        // Simple heuristic: if error is frequent, suggest retry
        if (errorPatterns[errorCode] ?? 0) > 3 {
            return recoveryStrategies["retry"]
        }
        return recoveryStrategies["fallback"]
    }
    
    public func recover(errorId: UUID, using strategyId: String) -> RecoveryResult {
        guard let error = errors[errorId], let strategy = recoveryStrategies[strategyId] else {
            return RecoveryResult(success: false, message: "Error or strategy not found")
        }
        
        // Simulate recovery
        var updatedError = error
        updatedError.isResolved = true
        errors[errorId] = updatedError
        
        return RecoveryResult(success: true, message: "Applied \(strategy.name) to \(error.code)")
    }
    
    public func registerStrategy(_ strategy: RecoveryStrategy) {
        recoveryStrategies[strategy.id] = strategy
    }
    
    public func getStrategies() -> [RecoveryStrategy] { Array(recoveryStrategies.values) }
    
    public func clearResolved() {
        errors = errors.filter { !$0.value.isResolved }
    }
    
    public var stats: ErrorStats {
        ErrorStats(
            totalErrors: errors.count,
            unresolvedErrors: errors.values.filter { !$0.isResolved }.count,
            bySeverity: Dictionary(grouping: errors.values, by: { $0.severity }).mapValues { $0.count },
            topPatterns: errorPatterns.sorted { $0.value > $1.value }.prefix(5).map { ($0.key, $0.value) }
        )
    }
}

// MARK: - Models

public struct RecordedError: Identifiable, Sendable {
    public let id: UUID
    public let code: String
    public let message: String
    public let severity: ErrorSeverity
    public let context: [String: String]
    public var isResolved: Bool
    public let recordedAt: Date
    
    public init(id: UUID = UUID(), code: String, message: String, severity: ErrorSeverity = .error, context: [String: String] = [:], isResolved: Bool = false, recordedAt: Date = Date()) {
        self.id = id
        self.code = code
        self.message = message
        self.severity = severity
        self.context = context
        self.isResolved = isResolved
        self.recordedAt = recordedAt
    }
}

public enum ErrorSeverity: String, Sendable, CaseIterable {
    case debug, info, warning, error, critical
}

public struct RecoveryStrategy: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let action: RecoveryAction
    
    public init(id: String, name: String, action: RecoveryAction) {
        self.id = id
        self.name = name
        self.action = action
    }
}

public enum RecoveryAction: Sendable {
    case retry(maxAttempts: Int)
    case ignore
    case fallback
    case escalate
    case custom(String)
}

public struct RecoveryResult: Sendable {
    public let success: Bool
    public let message: String
    
    public init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}

public struct ErrorStats: Sendable {
    public let totalErrors: Int
    public let unresolvedErrors: Int
    public let bySeverity: [ErrorSeverity: Int]
    public let topPatterns: [(String, Int)]
}
