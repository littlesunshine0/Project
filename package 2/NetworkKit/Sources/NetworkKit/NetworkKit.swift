//
//  NetworkKit.swift
//  NetworkKit - Network Discovery & Communication
//

import Foundation

// MARK: - Network Service

public struct NetworkService: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let type: String
    public let host: String
    public let port: Int
    public var metadata: [String: String]
    public let discoveredAt: Date
    
    public init(name: String, type: String, host: String, port: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.type = type
        self.host = host
        self.port = port
        self.metadata = [:]
        self.discoveredAt = Date()
    }
}

// MARK: - Network Peer

public struct NetworkPeer: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let address: String
    public var isConnected: Bool
    public let discoveredAt: Date
    
    public init(name: String, address: String) {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.isConnected = false
        self.discoveredAt = Date()
    }
}

// MARK: - Network Discovery

public actor NetworkDiscovery {
    public static let shared = NetworkDiscovery()
    
    private var services: [String: NetworkService] = [:]
    private var peers: [String: NetworkPeer] = [:]
    private var isScanning = false
    
    private init() {}
    
    public func startDiscovery(serviceType: String = "_http._tcp") {
        isScanning = true
        // Simulated discovery - in real implementation would use Bonjour/mDNS
    }
    
    public func stopDiscovery() {
        isScanning = false
    }
    
    public func registerService(name: String, type: String, port: Int) -> NetworkService {
        let service = NetworkService(name: name, type: type, host: "localhost", port: port)
        services[service.id] = service
        return service
    }
    
    public func unregisterService(_ id: String) {
        services.removeValue(forKey: id)
    }
    
    public func getServices() -> [NetworkService] {
        Array(services.values)
    }
    
    public func getServices(type: String) -> [NetworkService] {
        services.values.filter { $0.type == type }
    }
    
    public func addPeer(name: String, address: String) -> NetworkPeer {
        let peer = NetworkPeer(name: name, address: address)
        peers[peer.id] = peer
        return peer
    }
    
    public func connectPeer(_ id: String) -> Bool {
        guard var peer = peers[id] else { return false }
        peer.isConnected = true
        peers[id] = peer
        return true
    }
    
    public func disconnectPeer(_ id: String) {
        peers[id]?.isConnected = false
    }
    
    public func getPeers() -> [NetworkPeer] {
        Array(peers.values)
    }
    
    public func getConnectedPeers() -> [NetworkPeer] {
        peers.values.filter { $0.isConnected }
    }
    
    public var stats: NetworkStats {
        NetworkStats(
            serviceCount: services.count,
            peerCount: peers.count,
            connectedPeers: peers.values.filter { $0.isConnected }.count,
            isScanning: isScanning
        )
    }
}

public struct NetworkStats: Sendable {
    public let serviceCount: Int
    public let peerCount: Int
    public let connectedPeers: Int
    public let isScanning: Bool
}
