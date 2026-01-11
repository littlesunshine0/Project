import Testing
@testable import AnalyticsKit

@Suite("AnalyticsKit Tests")
struct AnalyticsKitTests {
    
    @Test("Track event")
    func testTrackEvent() async {
        await AnalyticsEngine.shared.track(name: "test_event", properties: ["key": "value"])
        let events = await AnalyticsEngine.shared.getEvents(limit: 10)
        #expect(events.contains { $0.name == "test_event" })
    }
    
    @Test("Record metric")
    func testRecordMetric() async {
        await AnalyticsEngine.shared.record(metric: "test_metric", value: 42.0)
        let metric = await AnalyticsEngine.shared.getMetric("test_metric")
        #expect(metric?.current == 42.0)
    }
    
    @Test("Increment metric")
    func testIncrementMetric() async {
        await AnalyticsEngine.shared.record(metric: "counter", value: 0)
        await AnalyticsEngine.shared.increment(metric: "counter")
        await AnalyticsEngine.shared.increment(metric: "counter", by: 5)
        let metric = await AnalyticsEngine.shared.getMetric("counter")
        #expect(metric?.current == 6.0)
    }
    
    @Test("Session management")
    func testSession() async {
        let sessionId = await AnalyticsEngine.shared.startSession(userId: "user123")
        await AnalyticsEngine.shared.endSession(sessionId)
        let stats = await AnalyticsEngine.shared.stats
        #expect(stats.totalSessions >= 1)
    }
    
    @Test("Telemetry recording")
    func testTelemetry() async {
        await TelemetryService.shared.record(name: "cpu_usage", value: 45.5, unit: "%")
        let points = await TelemetryService.shared.getPoints(name: "cpu_usage")
        #expect(!points.isEmpty)
    }
    
    @Test("Telemetry average")
    func testTelemetryAverage() async {
        await TelemetryService.shared.record(name: "memory", value: 100)
        await TelemetryService.shared.record(name: "memory", value: 200)
        let avg = await TelemetryService.shared.average(for: "memory")
        #expect(avg != nil)
    }
    
    @Test("Performance timer")
    func testPerformanceTimer() async {
        await PerformanceMonitor.shared.startTimer("test_op")
        try? await Task.sleep(nanoseconds: 1_000_000) // 1ms
        let duration = await PerformanceMonitor.shared.stopTimer("test_op")
        #expect(duration != nil)
        if let d = duration {
            #expect(d > 0)
        }
    }
    
    @Test("Performance stats")
    func testPerformanceStats() async {
        await PerformanceMonitor.shared.startTimer("stats_test")
        _ = await PerformanceMonitor.shared.stopTimer("stats_test")
        let stats = await PerformanceMonitor.shared.getStats(for: "stats_test")
        #expect(stats != nil)
        #expect((stats?.count ?? 0) >= 1)
    }
    
    @Test("Event categories")
    func testEventCategories() async {
        await AnalyticsEngine.shared.track(name: "error_event", category: .error)
        let errors = await AnalyticsEngine.shared.getEvents(category: .error)
        #expect(errors.contains { $0.name == "error_event" })
    }
}
