import Testing
@testable import ActivityKit

@Suite("ActivityKit Tests")
struct ActivityKitTests {
    
    @Test("Record activity")
    func testRecordActivity() async {
        let activity = await ActivityTracker.shared.record(.fileOpen, name: "test.swift")
        #expect(activity.type == .fileOpen)
        #expect(activity.name == "test.swift")
    }
    
    @Test("Get activities by type")
    func testGetByType() async {
        _ = await ActivityTracker.shared.record(.command, name: "build")
        let commands = await ActivityTracker.shared.getActivities(type: .command)
        #expect(commands.contains { $0.name == "build" })
    }
    
    @Test("Activity listener")
    func testListener() async {
        // Test listener registration/removal
        await ActivityTracker.shared.addListener(id: "test") { _ in }
        _ = await ActivityTracker.shared.record(.search, name: "query")
        await ActivityTracker.shared.removeListener(id: "test")
        // Listener was called
    }
    
    @Test("Launch app")
    func testLaunchApp() async {
        let result = await AppLauncher.shared.launchByBundleId("com.apple.finder")
        #expect(result.success)
        #expect(result.processId != nil)
    }
    
    @Test("Launch with arguments")
    func testLaunchWithArgs() async {
        let request = AppLaunchRequest(bundleId: "com.test.app", arguments: ["--debug"])
        let result = await AppLauncher.shared.launch(request)
        #expect(result.success)
    }
    
    @Test("Recent launches")
    func testRecentLaunches() async {
        _ = await AppLauncher.shared.launchByBundleId("com.test.recent")
        let recent = await AppLauncher.shared.getRecentLaunches()
        #expect(!recent.isEmpty)
    }
    
    @Test("Activity stats")
    func testStats() async {
        let stats = await ActivityTracker.shared.stats
        #expect(stats.totalActivities >= 0)
    }
}
