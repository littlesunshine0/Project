//
//  PricingModel.swift
//  DataKit
//

import Foundation

/// Pricing model for packages
public struct PricingModel: Codable, Sendable, Hashable {
    public let type: PricingType
    public let price: Decimal?
    public let currency: String
    public let interval: BillingInterval?
    public let trialDays: Int?
    
    public init(type: PricingType, price: Decimal? = nil, currency: String = "USD", interval: BillingInterval? = nil, trialDays: Int? = nil) {
        self.type = type
        self.price = price
        self.currency = currency
        self.interval = interval
        self.trialDays = trialDays
    }
    
    public static let free = PricingModel(type: .free)
    
    public var isFree: Bool { type == .free }
}

public enum PricingType: String, Codable, Sendable, CaseIterable {
    case free, oneTime, subscription, freemium
}

public enum BillingInterval: String, Codable, Sendable, CaseIterable {
    case monthly, yearly, lifetime
}
