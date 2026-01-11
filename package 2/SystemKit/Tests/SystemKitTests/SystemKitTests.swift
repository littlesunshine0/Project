import Testing
@testable import SystemKit

@Suite("SystemKit Tests")
struct SystemKitTests {
    
    @Test("Register service")
    func testRegisterService() async {
        await ServiceRegistry.shared.register(id: "test-service", name: "Test Service")
        let service = await ServiceRegistry.shared.get("test-service")
        #expect(service != nil)
    }
    
    @Test("Service dependencies")
    func testServiceDependencies() async {
        await ServiceRegistry.shared.addDependency(service: "app", dependsOn: "database")
        let deps = await ServiceRegistry.shared.getDependencies(for: "app")
        #expect(deps.contains("database"))
    }
    
    @Test("Permission request")
    func testPermissionRequest() async {
        let status = await PermissionManager.shared.request("camera")
        #expect(status == .granted)
    }
    
    @Test("Permission check")
    func testPermissionCheck() async {
        await PermissionManager.shared.grant("microphone")
        let status = await PermissionManager.shared.check("microphone")
        #expect(status == .granted)
    }
    
    @Test("Memory cache")
    func testMemoryCache() async {
        await MemoryOptimizer.shared.registerCache("images", size: 1024)
        let stats = await MemoryOptimizer.shared.stats
        #expect(stats.cacheCount >= 1)
    }
    
    @Test("Memory pressure")
    func testMemoryPressure() async {
        await MemoryOptimizer.shared.setMemoryPressure(.warning)
        let pressure = await MemoryOptimizer.shared.getMemoryPressure()
        #expect(pressure == .warning)
    }
    
    @Test("Performance optimization")
    func testPerformanceOptimization() async {
        let opt = Optimization(id: "lazy-load", name: "Lazy Loading")
        await PerformanceOptimizer.shared.registerOptimization(opt)
        let applied = await PerformanceOptimizer.shared.applyOptimization("lazy-load")
        #expect(applied)
    }
    
    @Test("Sandbox creation")
    func testSandboxCreation() async {
        let sandbox = await SandboxManager.shared.create(name: "test-sandbox", permissions: ["read", "write"])
        #expect(sandbox.name == "test-sandbox")
        #expect(sandbox.permissions.contains("read"))
    }
}
