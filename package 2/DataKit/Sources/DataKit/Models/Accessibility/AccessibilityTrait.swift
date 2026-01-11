//
//  AccessibilityTrait.swift
//  DataKit
//

import Foundation

public enum AccessibilityTrait: String, Codable, Sendable, CaseIterable {
    case button, link, header, image, selected, disabled, adjustable, summary, searchField, staticText
}
