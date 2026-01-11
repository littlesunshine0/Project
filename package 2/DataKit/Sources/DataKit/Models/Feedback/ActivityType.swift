//
//  ActivityType.swift
//  DataKit
//

import Foundation

public enum ActivityType: String, Codable, Sendable, CaseIterable {
    case view, create, update, delete, share, export, import_, search, navigate, execute
}
