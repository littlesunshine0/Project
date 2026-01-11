//
//  FeedbackModel.swift
//  DataKit
//

import Foundation

/// Feedback model for user input
public struct FeedbackModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: FeedbackType
    public let rating: Int?
    public let comment: String?
    public let context: [String: String]
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, type: FeedbackType, rating: Int? = nil, comment: String? = nil, context: [String: String] = [:]) {
        self.id = id
        self.type = type
        self.rating = rating
        self.comment = comment
        self.context = context
        self.timestamp = Date()
    }
}
