//
//  FlowKitPackageModels.swift
//  DataKit
//

import Foundation

/// Every package must conform to this protocol
/// Enables uniform CRUD, UI, ML reasoning, automation, documentation
public protocol FlowKitPackageModels {
    // Identity
    associatedtype Package: Identifiable & Codable & Sendable
    associatedtype Category: RawRepresentable & Codable & Sendable where Category.RawValue == String
    
    // Core
    associatedtype Node: Identifiable & Codable & Sendable
    associatedtype Action: Identifiable & Codable & Sendable
    associatedtype Result: Codable & Sendable
    associatedtype Error: Identifiable & Codable & Sendable & Swift.Error
    associatedtype State: Identifiable & Codable & Sendable
    associatedtype Event: Identifiable & Codable & Sendable
}
