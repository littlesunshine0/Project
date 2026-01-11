//
//  LicenseModel.swift
//  DataKit
//

import Foundation

/// License model for packages
public struct LicenseModel: Codable, Sendable, Hashable {
    public let type: LicenseType
    public let name: String
    public let url: String?
    public let text: String?
    
    public init(type: LicenseType, name: String? = nil, url: String? = nil, text: String? = nil) {
        self.type = type
        self.name = name ?? type.rawValue
        self.url = url
        self.text = text
    }
    
    public static let mit = LicenseModel(type: .mit)
    public static let apache2 = LicenseModel(type: .apache2)
    public static let proprietary = LicenseModel(type: .proprietary)
}

public enum LicenseType: String, Codable, Sendable, CaseIterable {
    case mit = "MIT"
    case apache2 = "Apache-2.0"
    case gpl3 = "GPL-3.0"
    case bsd3 = "BSD-3-Clause"
    case proprietary = "Proprietary"
    case custom = "Custom"
}
