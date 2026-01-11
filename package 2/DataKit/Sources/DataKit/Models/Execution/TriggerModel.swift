//
//  TriggerModel.swift
//  DataKit
//

import Foundation

public struct TriggerModel: Codable, Sendable, Hashable {
    public let type: TriggerType
    public let condition: String?
    
    public init(type: TriggerType, condition: String? = nil) {
        self.type = type
        self.condition = condition
    }
}
