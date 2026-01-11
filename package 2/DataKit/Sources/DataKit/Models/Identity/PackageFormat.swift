//
//  PackageFormat.swift
//  DataKit
//

import Foundation

public enum PackageFormat: String, Codable, Sendable, CaseIterable {
    case swift, json, yaml, markdown, binary
}
