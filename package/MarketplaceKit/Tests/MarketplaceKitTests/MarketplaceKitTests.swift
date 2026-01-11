import Testing
@testable import MarketplaceKit

@Suite("MarketplaceKit Tests")
struct MarketplaceKitTests {
    
    @Test("Add product")
    func testAddProduct() async {
        let product = Product(name: "Test Item", description: "A test product", price: 9.99)
        let added = await InventoryService.shared.addProduct(product)
        #expect(added.name == "Test Item")
    }
    
    @Test("Get product")
    func testGetProduct() async {
        let product = Product(name: "GetTest", description: "Test", price: 19.99)
        let added = await InventoryService.shared.addProduct(product)
        let retrieved = await InventoryService.shared.getProduct(added.id)
        #expect(retrieved?.name == "GetTest")
    }
    
    @Test("Update inventory")
    func testUpdateInventory() async {
        let product = Product(name: "InventoryTest", description: "Test", price: 5.00, inventory: 10)
        let added = await InventoryService.shared.addProduct(product)
        let updated = await InventoryService.shared.updateInventory(added.id, quantity: 50)
        #expect(updated)
    }
    
    @Test("Create listing")
    func testCreateListing() async {
        let listing = await MarketplaceService.shared.createListing(productId: "prod123", platform: "amazon")
        #expect(listing.platform == "amazon")
        #expect(listing.isActive)
    }
    
    @Test("Create order")
    func testCreateOrder() async {
        let order = await MarketplaceService.shared.createOrder(productIds: ["p1", "p2"], total: 29.99)
        #expect(order.status == .pending)
        #expect(order.total == 29.99)
    }
    
    @Test("Update order status")
    func testUpdateOrderStatus() async {
        let order = await MarketplaceService.shared.createOrder(productIds: ["p3"], total: 15.00)
        let updated = await MarketplaceService.shared.updateOrderStatus(order.id, status: .shipped)
        #expect(updated)
    }
    
    @Test("Get orders by status")
    func testGetOrdersByStatus() async {
        _ = await MarketplaceService.shared.createOrder(productIds: ["p4"], total: 10.00)
        let pending = await MarketplaceService.shared.getOrders(status: .pending)
        #expect(!pending.isEmpty)
    }
    
    @Test("Marketplace stats")
    func testStats() async {
        let stats = await MarketplaceService.shared.stats
        #expect(stats.listingCount >= 0)
    }
}
