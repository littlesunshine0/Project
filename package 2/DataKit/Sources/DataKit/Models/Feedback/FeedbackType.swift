//
//  FeedbackType.swift
//  DataKit
//

import Foundation

public enum FeedbackType: String, Codable, Sendable, CaseIterable {
    case rating, review, suggestion, bug, feature, general
}
