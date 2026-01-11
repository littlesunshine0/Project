//
//  ExecutionResult.swift
//  CommandKit
//

import Foundation

public struct ExecutionResult: Sendable {
    public let success: Bool
    public let output: String
    public let duration: TimeInterval
    public let command: Command
    
    public init(success: Bool, output: String, duration: TimeInterval, command: Command) {
        self.success = success
        self.output = output
        self.duration = duration
        self.command = command
    }
}
