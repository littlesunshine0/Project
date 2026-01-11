//
//  StepModel.swift
//  DataKit
//

import Foundation

/// Step in a workflow
public struct StepModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let action: String
    public let input: [String: AnyCodable]?
    public let condition: String?
    public let onSuccess: String?
    public let onFailure: String?
    
    public init(id: String, action: String, input: [String: AnyCodable]? = nil, condition: String? = nil, onSuccess: String? = nil, onFailure: String? = nil) {
        self.id = id
        self.action = action
        self.input = input
        self.condition = condition
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
}
