import Testing
@testable import AssetKit

@Suite("AssetKit Tests")
struct AssetKitTests {
    
    @Test("Add asset")
    func testAddAsset() async {
        let asset = await AssetLibrary.shared.addAsset(name: "logo.png", type: .image, path: "/assets/logo.png")
        #expect(asset.name == "logo.png")
        #expect(asset.type == .image)
    }
    
    @Test("Get asset")
    func testGetAsset() async {
        let added = await AssetLibrary.shared.addAsset(name: "icon.svg", type: .image, path: "/assets/icon.svg")
        let retrieved = await AssetLibrary.shared.getAsset(added.id)
        #expect(retrieved?.name == "icon.svg")
    }
    
    @Test("Tag asset")
    func testTagAsset() async {
        let asset = await AssetLibrary.shared.addAsset(name: "tagged.png", type: .image, path: "/assets/tagged.png")
        await AssetLibrary.shared.tagAsset(asset.id, tags: ["ui", "button"])
        let byTag = await AssetLibrary.shared.getAssets(byTag: "ui")
        #expect(byTag.contains { $0.id == asset.id })
    }
    
    @Test("Get by type")
    func testGetByType() async {
        _ = await AssetLibrary.shared.addAsset(name: "video.mp4", type: .video, path: "/assets/video.mp4")
        let videos = await AssetLibrary.shared.getAssets(byType: .video)
        #expect(videos.contains { $0.name == "video.mp4" })
    }
    
    @Test("Search assets")
    func testSearch() async {
        _ = await AssetLibrary.shared.addAsset(name: "searchable_icon.png", type: .image, path: "/assets/searchable.png")
        let results = await AssetLibrary.shared.search(query: "searchable")
        #expect(!results.isEmpty)
    }
    
    @Test("Create collection")
    func testCreateCollection() async {
        let collection = await AssetLibrary.shared.createCollection(name: "Icons")
        #expect(collection.name == "Icons")
    }
    
    @Test("Add to collection")
    func testAddToCollection() async {
        let asset = await AssetLibrary.shared.addAsset(name: "coll_asset.png", type: .image, path: "/assets/coll.png")
        let collection = await AssetLibrary.shared.createCollection(name: "TestColl")
        await AssetLibrary.shared.addToCollection(collection.id, assetId: asset.id)
        let retrieved = await AssetLibrary.shared.getCollection(collection.id)
        #expect(retrieved?.assetIds.contains(asset.id) == true)
    }
    
    @Test("Asset stats")
    func testStats() async {
        let stats = await AssetLibrary.shared.stats
        #expect(stats.totalAssets >= 0)
    }
}
