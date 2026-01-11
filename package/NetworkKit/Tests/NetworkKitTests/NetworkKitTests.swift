import Testing
@testable import NetworkKit

@Suite("NetworkKit Tests")
struct NetworkKitTests {
    
    @Test("Register service")
    func testRegisterService() async {
        let service = await NetworkDiscovery.shared.registerService(name: "TestService", type: "_http._tcp", port: 8080)
        #expect(service.name == "TestService")
        #expect(service.port == 8080)
    }
    
    @Test("Get services")
    func testGetServices() async {
        _ = await NetworkDiscovery.shared.registerService(name: "GetTest", type: "_test._tcp", port: 9000)
        let services = await NetworkDiscovery.shared.getServices()
        #expect(!services.isEmpty)
    }
    
    @Test("Filter services by type")
    func testFilterByType() async {
        _ = await NetworkDiscovery.shared.registerService(name: "TypeTest", type: "_custom._tcp", port: 9001)
        let filtered = await NetworkDiscovery.shared.getServices(type: "_custom._tcp")
        #expect(filtered.contains { $0.name == "TypeTest" })
    }
    
    @Test("Add peer")
    func testAddPeer() async {
        let peer = await NetworkDiscovery.shared.addPeer(name: "Peer1", address: "192.168.1.100")
        #expect(peer.name == "Peer1")
        #expect(!peer.isConnected)
    }
    
    @Test("Connect peer")
    func testConnectPeer() async {
        let peer = await NetworkDiscovery.shared.addPeer(name: "ConnectTest", address: "192.168.1.101")
        let connected = await NetworkDiscovery.shared.connectPeer(peer.id)
        #expect(connected)
    }
    
    @Test("Get connected peers")
    func testConnectedPeers() async {
        let peer = await NetworkDiscovery.shared.addPeer(name: "ConnectedTest", address: "192.168.1.102")
        _ = await NetworkDiscovery.shared.connectPeer(peer.id)
        let connected = await NetworkDiscovery.shared.getConnectedPeers()
        #expect(connected.contains { $0.name == "ConnectedTest" })
    }
    
    @Test("Network stats")
    func testStats() async {
        let stats = await NetworkDiscovery.shared.stats
        #expect(stats.serviceCount >= 0)
    }
}
