//
//  BannerModel.swift
//  DataKit
//

import Foundation

/// Banner model for prominent messages
public struct BannerModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: BannerType
    public let title: String
    public let message: String?
    public let action: BannerAction?
    public let isDismissible: Bool
    public let expiresAt: Date?
    
    public init(id: String = UUID().uuidString, type: BannerType, title: String, message: String? = nil, action: BannerAction? = nil, isDismissible: Bool = true, expiresAt: Date? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.action = action
        self.isDismissible = isDismissible
        self.expiresAt = expiresAt
    }
}
