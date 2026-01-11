//
//  EventBus.swift
//  DataKit
//
//  Cross-Kit Event System for automatic synchronization
//

import Foundation
import Combine

// MARK: - Event Bus

public actor EventBus {
    public static let shared = EventBus()
    
    private var subscribers: [String: [(DataEvent) async -> Void]] = [:]
    private var eventHistory: [DataEvent] = []
    private let maxHistory = 1000
    
    private init() {}
    
    // MARK: - Subscribe
    
    public func subscribe(to eventType: String, handler: @escaping (DataEvent) async -> Void) {
        subscribers[eventType, default: []].append(handler)
    }
    
    public func subscribeAll(handler: @escaping (DataEvent) async -> Void) {
        subscribe(to: "*", handler: handler)
    }
    
    // MARK: - Publish
    
    public func publish(_ event: DataEvent) async {
        eventHistory.append(event)
        if eventHistory.count > maxHistory {
            eventHistory.removeFirst()
        }
        
        // Notify specific subscribers
        if let handlers = subscribers[event.type] {
            for handler in handlers {
                await handler(event)
            }
        }
        
        // Notify wildcard subscribers
        if let wildcardHandlers = subscribers["*"] {
            for handler in wildcardHandlers {
                await handler(event)
            }
        }
    }
    
    // MARK: - Convenience Publishers
    
    public func entityCreated(entityType: String, entityId: UUID, kit: String) async {
        await publish(DataEvent(
            type: "\(kit).created",
            entityType: entityType,
            entityId: entityId,
            payload: ["action": "create"],
            source: kit
        ))
    }
    
    public func entityUpdated(entityType: String, entityId: UUID, kit: String) async {
        await publish(DataEvent(
            type: "\(kit).updated",
            entityType: entityType,
            entityId: entityId,
            payload: ["action": "update"],
            source: kit
        ))
    }
    
    public func entityDeleted(entityType: String, entityId: UUID, kit: String) async {
        await publish(DataEvent(
            type: "\(kit).deleted",
            entityType: entityType,
            entityId: entityId,
            payload: ["action": "delete"],
            source: kit
        ))
    }
    
    // MARK: - Generic Event Emit (alias for publish)
    
    public func emit(_ event: any Sendable) async {
        // Convert any sendable event to DataEvent for unified handling
        let dataEvent = DataEvent(
            type: String(describing: type(of: event)),
            entityType: "Event",
            entityId: UUID(),
            payload: [:],
            source: "EventBus"
        )
        await publish(dataEvent)
    }
    
    // MARK: - History
    
    public func getHistory(limit: Int = 100) -> [DataEvent] {
        Array(eventHistory.suffix(limit))
    }
    
    public func getHistory(for kit: String, limit: Int = 50) -> [DataEvent] {
        eventHistory.filter { $0.source == kit }.suffix(limit).map { $0 }
    }
}

// MARK: - Data Event

public struct DataEvent: Identifiable, Sendable {
    public let id: UUID
    public let type: String
    public let entityType: String
    public let entityId: UUID
    public let payload: [String: String]
    public let source: String
    public let timestamp: Date
    
    public init(
        id: UUID = UUID(),
        type: String,
        entityType: String,
        entityId: UUID,
        payload: [String: String] = [:],
        source: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.entityType = entityType
        self.entityId = entityId
        self.payload = payload
        self.source = source
        self.timestamp = timestamp
    }
}
