//
//  EncodingModel.swift
//  DataKit
//

import Foundation

/// Encoding model
public struct EncodingModel: Codable, Sendable, Hashable {
    public let name: String
    public let charset: String
    public let bom: Bool
    
    public init(name: String = "UTF-8", charset: String = "utf-8", bom: Bool = false) {
        self.name = name
        self.charset = charset
        self.bom = bom
    }
    
    public static let utf8 = EncodingModel(name: "UTF-8", charset: "utf-8")
    public static let utf16 = EncodingModel(name: "UTF-16", charset: "utf-16")
    public static let ascii = EncodingModel(name: "ASCII", charset: "us-ascii")
}
