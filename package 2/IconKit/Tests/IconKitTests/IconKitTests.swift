//
//  IconKitTests.swift
//  IconKit Tests
//

import XCTest
import SwiftUI
@testable import IconKit

final class IconKitTests: XCTestCase {
    
    // MARK: - IconKit Tests
    
    func testIconKitVersion() {
        XCTAssertEqual(IconKit.version, "2.0.0")
    }
    
    func testIconCategories() {
        XCTAssertEqual(IconKit.IconCategory.allCases.count, 6)
    }
    
    func testCategoryDefaultIcons() {
        XCTAssertEqual(IconKit.IconCategory.project.defaultIcon, .glowOrb)
        XCTAssertEqual(IconKit.IconCategory.package.defaultIcon, .cube)
        XCTAssertEqual(IconKit.IconCategory.feature.defaultIcon, .star)
        XCTAssertEqual(IconKit.IconCategory.service.defaultIcon, .gear)
        XCTAssertEqual(IconKit.IconCategory.module.defaultIcon, .layers)
        XCTAssertEqual(IconKit.IconCategory.capability.defaultIcon, .lightbulb)
    }
    
    func testCategorySystemImages() {
        XCTAssertEqual(IconKit.IconCategory.project.systemImage, "folder.fill")
        XCTAssertEqual(IconKit.IconCategory.package.systemImage, "shippingbox.fill")
    }
    
    // MARK: - IconStyle Tests
    
    func testIconStyleCount() {
        XCTAssertEqual(IconStyle.allCases.count, 18)
    }
    
    func testIconStyleDefaultColors() {
        let glowOrb = IconStyle.glowOrb
        XCTAssertEqual(glowOrb.defaultColors.count, 3)
        
        let minimal = IconStyle.minimal
        XCTAssertEqual(minimal.defaultColors.count, 2)
    }
    
    // MARK: - IconDefinition Tests
    
    func testIconDefinitionCreation() {
        let icon = IconDefinition(
            name: "TestIcon",
            category: .package,
            style: .cube
        )
        
        XCTAssertEqual(icon.name, "TestIcon")
        XCTAssertEqual(icon.category, .package)
        XCTAssertEqual(icon.style, .cube)
    }
    
    func testIconDefinitionFilename() {
        let icon = IconDefinition(
            name: "My Package",
            category: .package
        )
        
        XCTAssertEqual(icon.filename, "package_my_package")
    }
    
    func testIconDefinitionDefaultStyle() {
        let icon = IconDefinition(
            name: "Test",
            category: .feature
        )
        
        XCTAssertEqual(icon.style, .star) // Default for feature
    }
    
    // MARK: - IconSizeConfig Tests
    
    func testMacOSAppIconSizes() {
        let sizes = IconSizeConfig.macOSAppIcon
        XCTAssertEqual(sizes.count, 10)
    }
    
    func testImageAssetSizes() {
        let sizes = IconSizeConfig.imageAsset
        XCTAssertEqual(sizes.count, 3)
    }
    
    // MARK: - IconRegistry Tests
    
    func testIconRegistryDefaultCapabilities() async {
        let count = await IconKit.registry.count()
        XCTAssertEqual(count, 8) // 8 universal capabilities
    }
    
    func testIconRegistryRegister() async {
        let icon = IconDefinition(
            id: "test_icon",
            name: "Test",
            category: .module
        )
        
        await IconKit.registry.register(icon)
        
        let retrieved = await IconKit.registry.get("test_icon")
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.name, "Test")
    }
    
    func testIconRegistryGetByCategory() async {
        let capabilities = await IconKit.registry.icons(for: .capability)
        XCTAssertEqual(capabilities.count, 8)
    }
    
    // MARK: - IconSet Tests
    
    func testIconSetCreation() {
        let definition = IconDefinition(
            name: "Test",
            category: .package
        )
        
        let iconSet = IconSet(definition: definition)
        
        XCTAssertEqual(iconSet.definition.name, "Test")
        XCTAssertEqual(iconSet.sizes.count, 3) // Default imageAsset sizes
        XCTAssertEqual(iconSet.format, .png)
    }
    
    // MARK: - ColorScheme Tests
    
    func testDefaultColorScheme() {
        let scheme = IconColorScheme.default
        XCTAssertEqual(scheme.primary, .blue)
    }
    
    func testWarmColorScheme() {
        let scheme = IconColorScheme.warm
        XCTAssertNotEqual(scheme.primary, .blue)
    }
    
    // MARK: - StoredIcon Tests
    
    func testStoredIconCreation() {
        let icon = StoredIcon(
            name: "TestIcon",
            category: .package,
            style: .cube,
            description: "Test description",
            tags: ["test", "package"]
        )
        
        XCTAssertEqual(icon.name, "TestIcon")
        XCTAssertEqual(icon.category, "Package")
        XCTAssertEqual(icon.style, "cube")
        XCTAssertEqual(icon.tags.count, 2)
        XCTAssertFalse(icon.isCustom)
    }
    
    func testStoredIconDefinitionConversion() {
        let stored = StoredIcon(
            id: "test_id",
            name: "Test",
            category: .module,
            style: .layers
        )
        
        let definition = stored.definition
        XCTAssertEqual(definition.id, "test_id")
        XCTAssertEqual(definition.name, "Test")
        XCTAssertEqual(definition.style, .layers)
    }
    
    func testStoredIconCategoryConversion() {
        let icon = StoredIcon(name: "Test", category: .capability, style: .lightbulb)
        XCTAssertEqual(icon.iconCategory, .capability)
        XCTAssertEqual(icon.iconStyle, .lightbulb)
    }
    
    // MARK: - IconVariant Tests
    
    func testIconVariantDefaults() {
        let defaults = IconVariant.defaultVariants
        XCTAssertEqual(defaults.count, 5)
        XCTAssertTrue(defaults.contains { $0.type == .appIcon })
        XCTAssertTrue(defaults.contains { $0.type == .lineArt })
        XCTAssertTrue(defaults.contains { $0.type == .monochrome })
    }
    
    func testVariantTypeDisplayNames() {
        XCTAssertEqual(VariantType.appIcon.displayName, "App Icon")
        XCTAssertEqual(VariantType.lineArt.displayName, "Line Art")
        XCTAssertEqual(VariantType.monochrome.displayName, "Monochrome")
    }
    
    // MARK: - Color Extension Tests
    
    func testColorFromHex() {
        let color = Color(hex: "#FF0000")
        XCTAssertNotNil(color)
        
        let colorNoHash = Color(hex: "00FF00")
        XCTAssertNotNil(colorNoHash)
        
        let invalidColor = Color(hex: "invalid")
        XCTAssertNil(invalidColor)
    }
    
    // MARK: - IconStorageService Tests
    
    func testStorageServiceInitialization() async throws {
        try await IconStorageService.shared.initialize()
        let count = await IconStorageService.shared.count()
        XCTAssertGreaterThan(count, 0)
    }
    
    func testStorageServiceFetchAll() async throws {
        try await IconStorageService.shared.initialize()
        let icons = await IconStorageService.shared.fetchAll()
        XCTAssertGreaterThan(icons.count, 0)
    }
    
    func testStorageServiceFetchByCategory() async throws {
        try await IconStorageService.shared.initialize()
        let capabilities = await IconStorageService.shared.fetch(category: .capability)
        XCTAssertEqual(capabilities.count, 8)
    }
    
    func testStorageServiceSearch() async throws {
        try await IconStorageService.shared.initialize()
        let results = await IconStorageService.shared.search(query: "FlowKit")
        XCTAssertGreaterThan(results.count, 0)
    }
    
    // MARK: - BatchResult Tests
    
    func testBatchResultSuccessRate() {
        let result = BatchResult(total: 10, succeeded: 8, failed: 2, errors: ["Error 1", "Error 2"])
        XCTAssertEqual(result.successRate, 80.0)
        XCTAssertTrue(result.summary.contains("8/10"))
    }
    
    func testBatchResultZeroTotal() {
        let result = BatchResult(total: 0, succeeded: 0, failed: 0, errors: [])
        XCTAssertEqual(result.successRate, 0)
    }
}
