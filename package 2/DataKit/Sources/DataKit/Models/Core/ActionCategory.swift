//
//  ActionCategory.swift
//  DataKit
//

import Foundation

public enum ActionCategory: String, Codable, Sendable, CaseIterable {
    case create, read, update, delete, execute, navigate, export, share, general
}
