import Testing
@testable import ErrorKit

@Suite("ErrorKit Tests")
struct ErrorKitTests {
    
    @Test("Record error")
    func testRecordError() async {
        let id = await ErrorRecoveryEngine.shared.record(code: "E001", message: "Test error")
        let error = await ErrorRecoveryEngine.shared.getError(id)
        #expect(error != nil)
        #expect(error?.code == "E001")
    }
    
    @Test("Get by severity")
    func testGetBySeverity() async {
        _ = await ErrorRecoveryEngine.shared.record(code: "CRIT", message: "Critical error", severity: .critical)
        let critical = await ErrorRecoveryEngine.shared.getBySeverity(.critical)
        #expect(!critical.isEmpty)
    }
    
    @Test("Suggest recovery")
    func testSuggestRecovery() async {
        // Record same error multiple times to trigger retry suggestion
        for _ in 0..<5 {
            _ = await ErrorRecoveryEngine.shared.record(code: "FREQ", message: "Frequent error")
        }
        let strategy = await ErrorRecoveryEngine.shared.suggestRecovery(for: "FREQ")
        #expect(strategy != nil)
    }
    
    @Test("Recover from error")
    func testRecover() async {
        let id = await ErrorRecoveryEngine.shared.record(code: "REC", message: "Recoverable")
        let result = await ErrorRecoveryEngine.shared.recover(errorId: id, using: "retry")
        #expect(result.success)
    }
    
    @Test("Register strategy")
    func testRegisterStrategy() async {
        let strategy = RecoveryStrategy(id: "custom", name: "Custom", action: .custom("do something"))
        await ErrorRecoveryEngine.shared.registerStrategy(strategy)
        let strategies = await ErrorRecoveryEngine.shared.getStrategies()
        #expect(strategies.contains { $0.id == "custom" })
    }
    
    @Test("Error stats")
    func testErrorStats() async {
        let stats = await ErrorRecoveryEngine.shared.stats
        #expect(stats.totalErrors >= 0)
    }
}
