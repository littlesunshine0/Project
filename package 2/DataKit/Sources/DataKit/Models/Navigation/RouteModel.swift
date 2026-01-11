//
//  RouteModel.swift
//  DataKit
//

import Foundation

/// Route definition for navigation
public struct RouteModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let path: String
    public let destination: String
    public let parameters: [String: String]
    public let isDeepLink: Bool
    public let requiresAuth: Bool
    
    public init(id: String, path: String, destination: String, parameters: [String: String] = [:], isDeepLink: Bool = false, requiresAuth: Bool = false) {
        self.id = id
        self.path = path
        self.destination = destination
        self.parameters = parameters
        self.isDeepLink = isDeepLink
        self.requiresAuth = requiresAuth
    }
}
