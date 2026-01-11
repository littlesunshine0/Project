//
//  StateModel.swift
//  DataKit
//

import Foundation

/// Universal state model
public struct StateModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let icon: String
    public let color: String
    public let isTerminal: Bool
    
    public init(id: String, name: String, icon: String = "circle", color: String = "gray", isTerminal: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.isTerminal = isTerminal
    }
    
    public static let idle = StateModel(id: "idle", name: "Idle", icon: "circle", color: "gray")
    public static let loading = StateModel(id: "loading", name: "Loading", icon: "arrow.clockwise", color: "blue")
    public static let running = StateModel(id: "running", name: "Running", icon: "play.fill", color: "green")
    public static let error = StateModel(id: "error", name: "Error", icon: "exclamationmark.triangle", color: "red")
    public static let completed = StateModel(id: "completed", name: "Completed", icon: "checkmark.circle", color: "green", isTerminal: true)
}
