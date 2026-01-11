//
//  RecommendationType.swift
//  DataKit
//

import Foundation

public enum RecommendationType: String, Codable, Sendable, CaseIterable {
    case action, content, workflow, command, setting, feature
}
