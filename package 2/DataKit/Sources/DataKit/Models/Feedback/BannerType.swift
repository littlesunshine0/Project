//
//  BannerType.swift
//  DataKit
//

import Foundation

public enum BannerType: String, Codable, Sendable, CaseIterable {
    case info, success, warning, error, announcement, promotion
}
