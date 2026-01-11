//
//  ErrorCategory.swift
//  DataKit
//

import Foundation

public enum ErrorCategory: String, Codable, Sendable, CaseIterable {
    case validation, network, storage, permission, timeout, notFound, conflict, unknown, system
}
