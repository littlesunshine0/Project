//
//  MarketplaceKit.swift
//  MarketplaceKit - Marketplace Integration & E-commerce
//

import Foundation

// MARK: - Product

public struct Product: Identifiable, Sendable {
    public let id: String
    public var name: String
    public var description: String
    public var price: Decimal
    public var currency: String
    public var inventory: Int
    public var tags: [String]
    public let createdAt: Date
    
    public init(name: String, description: String, price: Decimal, currency: String = "USD", inventory: Int = 0) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.price = price
        self.currency = currency
        self.inventory = inventory
        self.tags = []
        self.createdAt = Date()
    }
}

// MARK: - Order

public struct Order: Identifiable, Sendable {
    public let id: String
    public let productIds: [String]
    public let total: Decimal
    public let currency: String
    public var status: OrderStatus
    public let createdAt: Date
    
    public init(productIds: [String], total: Decimal, currency: String = "USD") {
        self.id = UUID().uuidString
        self.productIds = productIds
        self.total = total
        self.currency = currency
        self.status = .pending
        self.createdAt = Date()
    }
}

public enum OrderStatus: String, Sendable {
    case pending, confirmed, shipped, delivered, cancelled
}

// MARK: - Listing

public struct Listing: Identifiable, Sendable {
    public let id: String
    public let productId: String
    public let platform: String
    public var isActive: Bool
    public let listedAt: Date
    
    public init(productId: String, platform: String) {
        self.id = UUID().uuidString
        self.productId = productId
        self.platform = platform
        self.isActive = true
        self.listedAt = Date()
    }
}

// MARK: - Inventory Service

public actor InventoryService {
    public static let shared = InventoryService()
    
    private var products: [String: Product] = [:]
    
    private init() {}
    
    public func addProduct(_ product: Product) -> Product {
        var p = product
        products[p.id] = p
        return p
    }
    
    public func getProduct(_ id: String) -> Product? {
        products[id]
    }
    
    public func updateInventory(_ productId: String, quantity: Int) -> Bool {
        guard var product = products[productId] else { return false }
        product.inventory = quantity
        products[productId] = product
        return true
    }
    
    public func adjustInventory(_ productId: String, delta: Int) -> Bool {
        guard var product = products[productId] else { return false }
        product.inventory += delta
        products[productId] = product
        return true
    }
    
    public func getLowStock(threshold: Int = 10) -> [Product] {
        products.values.filter { $0.inventory <= threshold }
    }
    
    public func getAllProducts() -> [Product] {
        Array(products.values)
    }
}

// MARK: - Marketplace Service

public actor MarketplaceService {
    public static let shared = MarketplaceService()
    
    private var listings: [String: Listing] = [:]
    private var orders: [String: Order] = [:]
    
    private init() {}
    
    public func createListing(productId: String, platform: String) -> Listing {
        let listing = Listing(productId: productId, platform: platform)
        listings[listing.id] = listing
        return listing
    }
    
    public func getListing(_ id: String) -> Listing? {
        listings[id]
    }
    
    public func getListings(platform: String) -> [Listing] {
        listings.values.filter { $0.platform == platform }
    }
    
    public func deactivateListing(_ id: String) {
        listings[id]?.isActive = false
    }
    
    public func createOrder(productIds: [String], total: Decimal) -> Order {
        let order = Order(productIds: productIds, total: total)
        orders[order.id] = order
        return order
    }
    
    public func getOrder(_ id: String) -> Order? {
        orders[id]
    }
    
    public func updateOrderStatus(_ orderId: String, status: OrderStatus) -> Bool {
        guard var order = orders[orderId] else { return false }
        order.status = status
        orders[orderId] = order
        return true
    }
    
    public func getOrders(status: OrderStatus? = nil) -> [Order] {
        if let status = status {
            return orders.values.filter { $0.status == status }
        }
        return Array(orders.values)
    }
    
    public var stats: MarketplaceStats {
        MarketplaceStats(
            listingCount: listings.count,
            activeListings: listings.values.filter { $0.isActive }.count,
            orderCount: orders.count,
            pendingOrders: orders.values.filter { $0.status == .pending }.count
        )
    }
}

public struct MarketplaceStats: Sendable {
    public let listingCount: Int
    public let activeListings: Int
    public let orderCount: Int
    public let pendingOrders: Int
}
