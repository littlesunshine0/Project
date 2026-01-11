//
//  PackageListing.swift
//  DataKit
//

import Foundation

/// Marketplace package listing
public struct PackageListing: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let packageId: String
    public let name: String
    public let description: String
    public let shortDescription: String
    public let icon: String
    public let screenshots: [String]
    public let category: PackageCategory
    public let tags: [String]
    public let author: String
    public let version: String
    public let pricing: PricingModel
    public let license: LicenseModel
    public let rating: Double
    public let reviewCount: Int
    public let downloadCount: Int
    public let publishedAt: Date
    public var updatedAt: Date
    
    public init(id: String, packageId: String, name: String, description: String, shortDescription: String = "", icon: String, screenshots: [String] = [], category: PackageCategory, tags: [String] = [], author: String, version: String, pricing: PricingModel = .free, license: LicenseModel = .mit, rating: Double = 0, reviewCount: Int = 0, downloadCount: Int = 0) {
        self.id = id
        self.packageId = packageId
        self.name = name
        self.description = description
        self.shortDescription = shortDescription.isEmpty ? String(description.prefix(100)) : shortDescription
        self.icon = icon
        self.screenshots = screenshots
        self.category = category
        self.tags = tags
        self.author = author
        self.version = version
        self.pricing = pricing
        self.license = license
        self.rating = rating
        self.reviewCount = reviewCount
        self.downloadCount = downloadCount
        self.publishedAt = Date()
        self.updatedAt = Date()
    }
}
