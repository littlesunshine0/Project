//
//  NLUKitTests.swift
//  NLUKit
//

import XCTest
@testable import NLUKit

final class NLUKitTests: XCTestCase {
    
    func testIntentClassification() async {
        let intent = await NLUKit.classifyIntent("create a new workflow")
        XCTAssertEqual(intent.type, .createWorkflow)
        XCTAssertGreaterThan(intent.confidence, 0.3)
    }
    
    func testExecuteIntent() async {
        let intent = await NLUKit.classifyIntent("run the build workflow")
        XCTAssertEqual(intent.type, .executeWorkflow)
    }
    
    func testHelpIntent() async {
        let intent = await NLUKit.classifyIntent("help me")
        XCTAssertEqual(intent.type, .help)
    }
    
    func testSearchIntent() async {
        let intent = await NLUKit.classifyIntent("search docs for SwiftUI")
        XCTAssertEqual(intent.type, .searchDocumentation)
    }
    
    func testEntityExtraction() async {
        let entities = await NLUKit.extractEntities("run \"my workflow\" at /path/to/file")
        
        XCTAssertTrue(entities.contains { $0.type == .workflowName && $0.value == "my workflow" })
        XCTAssertTrue(entities.contains { $0.type == .directoryPath })
    }
    
    func testURLExtraction() async {
        let entities = await NLUKit.extractEntities("check https://example.com/api")
        XCTAssertTrue(entities.contains { $0.type == .url })
    }
    
    func testNumberExtraction() async {
        let entities = await NLUKit.extractEntities("run 5 times")
        XCTAssertTrue(entities.contains { $0.type == .number && $0.value == "5" })
    }
    
    func testRealtimePrediction() async {
        let prediction = await NLUKit.predictRealtime("create workflow")
        
        XCTAssertTrue(prediction.isPartial)
        XCTAssertTrue(prediction.latency < 1.0) // Should be fast
    }
    
    func testShortInputPrediction() async {
        let prediction = await NLUKit.predictRealtime("cr")
        XCTAssertEqual(prediction.intent.type, .unknown)
    }
    
    func testEmbedding() async {
        let embedding = await NLUKit.embed("test text")
        XCTAssertEqual(embedding.count, 384)
    }
    
    func testAllIntentTypes() {
        let types = IntentType.allCases
        XCTAssertTrue(types.count >= 25)
        
        for type in types {
            XCTAssertFalse(type.description.isEmpty)
        }
    }
    
    func testAllEntityTypes() {
        let types = EntityType.allCases
        XCTAssertTrue(types.count >= 12)
    }
    
    func testIntentCodable() throws {
        let intent = Intent(type: .createWorkflow, confidence: 0.9, entities: [Entity(type: .workflowName, value: "test")])
        
        let data = try JSONEncoder().encode(intent)
        let decoded = try JSONDecoder().decode(Intent.self, from: data)
        
        XCTAssertEqual(decoded.type, intent.type)
        XCTAssertEqual(decoded.confidence, intent.confidence)
        XCTAssertEqual(decoded.entities.count, 1)
    }
}
