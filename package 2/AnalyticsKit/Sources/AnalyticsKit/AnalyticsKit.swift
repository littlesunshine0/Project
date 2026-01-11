//
//  AnalyticsKit.swift
//  AnalyticsKit
//
//  Analytics, telemetry, and performance monitoring
//

import Foundation

public struct AnalyticsKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.analyticskit"
    public init() {}
}

// MARK: - Analytics Engine

public actor AnalyticsEngine {
    public static let shared = AnalyticsEngine()
    
    private var events: [AnalyticsEvent] = []
    private var metrics: [String: MetricValue] = [:]
    private var sessions: [UUID: Session] = [:]
    
    private init() {}
    
    // MARK: - Event Tracking
    
    public func track(_ event: AnalyticsEvent) {
        events.append(event)
        if events.count > 10000 { events.removeFirst(events.count - 10000) }
    }
    
    public func track(name: String, properties: [String: String] = [:], category: EventCategory = .general) {
        let event = AnalyticsEvent(name: name, properties: properties, category: category)
        track(event)
    }
    
    // MARK: - Metrics
    
    public func record(metric: String, value: Double) {
        if var existing = metrics[metric] {
            existing.update(value)
            metrics[metric] = existing
        } else {
            metrics[metric] = MetricValue(name: metric, value: value)
        }
    }
    
    public func increment(metric: String, by amount: Double = 1) {
        let current = metrics[metric]?.current ?? 0
        record(metric: metric, value: current + amount)
    }
    
    public func getMetric(_ name: String) -> MetricValue? { metrics[name] }
    public func getAllMetrics() -> [MetricValue] { Array(metrics.values) }
    
    // MARK: - Sessions
    
    public func startSession(userId: String? = nil) -> UUID {
        let session = Session(userId: userId)
        sessions[session.id] = session
        track(name: "session_start", category: .session)
        return session.id
    }
    
    public func endSession(_ id: UUID) {
        if var session = sessions[id] {
            session.end()
            sessions[id] = session
            track(name: "session_end", properties: ["duration": "\(session.duration ?? 0)"], category: .session)
        }
    }
    
    // MARK: - Queries
    
    public func getEvents(category: EventCategory? = nil, limit: Int = 100) -> [AnalyticsEvent] {
        var result = events
        if let cat = category { result = result.filter { $0.category == cat } }
        return Array(result.suffix(limit))
    }
    
    public func getEventCount(name: String) -> Int {
        events.filter { $0.name == name }.count
    }
    
    public var stats: AnalyticsStats {
        AnalyticsStats(
            totalEvents: events.count,
            totalMetrics: metrics.count,
            activeSessions: sessions.filter { $0.value.endedAt == nil }.count,
            totalSessions: sessions.count
        )
    }
}

// MARK: - Telemetry Service

public actor TelemetryService {
    public static let shared = TelemetryService()
    
    private var telemetry: [TelemetryPoint] = []
    private var isEnabled = true
    
    private init() {}
    
    public func record(_ point: TelemetryPoint) {
        guard isEnabled else { return }
        telemetry.append(point)
        if telemetry.count > 5000 { telemetry.removeFirst(telemetry.count - 5000) }
    }
    
    public func record(name: String, value: Double, unit: String = "", tags: [String: String] = [:]) {
        record(TelemetryPoint(name: name, value: value, unit: unit, tags: tags))
    }
    
    public func enable() { isEnabled = true }
    public func disable() { isEnabled = false }
    
    public func getPoints(name: String? = nil, limit: Int = 100) -> [TelemetryPoint] {
        var result = telemetry
        if let n = name { result = result.filter { $0.name == n } }
        return Array(result.suffix(limit))
    }
    
    public func average(for name: String) -> Double? {
        let points = telemetry.filter { $0.name == name }
        guard !points.isEmpty else { return nil }
        return points.reduce(0) { $0 + $1.value } / Double(points.count)
    }
}

// MARK: - Performance Monitor

public actor PerformanceMonitor {
    public static let shared = PerformanceMonitor()
    
    private var measurements: [String: [PerformanceMeasurement]] = [:]
    private var activeTimers: [String: Date] = [:]
    
    private init() {}
    
    public func startTimer(_ name: String) {
        activeTimers[name] = Date()
    }
    
    public func stopTimer(_ name: String) -> TimeInterval? {
        guard let start = activeTimers.removeValue(forKey: name) else { return nil }
        let duration = Date().timeIntervalSince(start)
        
        let measurement = PerformanceMeasurement(name: name, duration: duration)
        measurements[name, default: []].append(measurement)
        
        // Keep last 100 per metric
        if measurements[name]!.count > 100 {
            measurements[name]!.removeFirst(measurements[name]!.count - 100)
        }
        
        return duration
    }
    
    public func measure<T>(_ name: String, operation: () throws -> T) rethrows -> T {
        let start = Date()
        defer {
            let duration = Date().timeIntervalSince(start)
            let measurement = PerformanceMeasurement(name: name, duration: duration)
            measurements[name, default: []].append(measurement)
        }
        return try operation()
    }
    
    public func getStats(for name: String) -> PerformanceStats? {
        guard let m = measurements[name], !m.isEmpty else { return nil }
        let durations = m.map { $0.duration }
        return PerformanceStats(
            name: name,
            count: m.count,
            average: durations.reduce(0, +) / Double(m.count),
            min: durations.min() ?? 0,
            max: durations.max() ?? 0
        )
    }
    
    public func getAllStats() -> [PerformanceStats] {
        measurements.keys.compactMap { getStats(for: $0) }
    }
}

// MARK: - Models

public struct AnalyticsEvent: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let properties: [String: String]
    public let category: EventCategory
    public let timestamp: Date
    
    public init(id: UUID = UUID(), name: String, properties: [String: String] = [:], category: EventCategory = .general, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.properties = properties
        self.category = category
        self.timestamp = timestamp
    }
}

public enum EventCategory: String, Sendable, CaseIterable {
    case general, user, system, error, session, performance, feature
}

public struct MetricValue: Sendable {
    public let name: String
    public private(set) var current: Double
    public private(set) var min: Double
    public private(set) var max: Double
    public private(set) var sum: Double
    public private(set) var count: Int
    public var average: Double { count > 0 ? sum / Double(count) : 0 }
    
    public init(name: String, value: Double) {
        self.name = name
        self.current = value
        self.min = value
        self.max = value
        self.sum = value
        self.count = 1
    }
    
    public mutating func update(_ value: Double) {
        current = value
        min = Swift.min(min, value)
        max = Swift.max(max, value)
        sum += value
        count += 1
    }
}

public struct Session: Identifiable, Sendable {
    public let id: UUID
    public let userId: String?
    public let startedAt: Date
    public private(set) var endedAt: Date?
    public var duration: TimeInterval? { endedAt?.timeIntervalSince(startedAt) }
    
    public init(id: UUID = UUID(), userId: String? = nil) {
        self.id = id
        self.userId = userId
        self.startedAt = Date()
    }
    
    public mutating func end() { endedAt = Date() }
}

public struct TelemetryPoint: Sendable {
    public let name: String
    public let value: Double
    public let unit: String
    public let tags: [String: String]
    public let timestamp: Date
    
    public init(name: String, value: Double, unit: String = "", tags: [String: String] = [:], timestamp: Date = Date()) {
        self.name = name
        self.value = value
        self.unit = unit
        self.tags = tags
        self.timestamp = timestamp
    }
}

public struct PerformanceMeasurement: Sendable {
    public let name: String
    public let duration: TimeInterval
    public let timestamp: Date
    
    public init(name: String, duration: TimeInterval, timestamp: Date = Date()) {
        self.name = name
        self.duration = duration
        self.timestamp = timestamp
    }
}

public struct PerformanceStats: Sendable {
    public let name: String
    public let count: Int
    public let average: TimeInterval
    public let min: TimeInterval
    public let max: TimeInterval
}

public struct AnalyticsStats: Sendable {
    public let totalEvents: Int
    public let totalMetrics: Int
    public let activeSessions: Int
    public let totalSessions: Int
}
