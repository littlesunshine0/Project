//
//  PackageSection.swift
//  DataKit
//

import Foundation

public enum PackageSection: String, Codable, Sendable, CaseIterable {
    case models, views, services, actions, agents, workflows, resources
}
