//
//  ResultModel.swift
//  DataKit
//

import Foundation

/// Universal result wrapper
public struct ResultModel<T: Codable & Sendable>: Codable, Sendable {
    public let success: Bool
    public let data: T?
    public let error: ErrorModel?
    public let metadata: ResultMetadata
    
    public init(success: Bool, data: T? = nil, error: ErrorModel? = nil, metadata: ResultMetadata = ResultMetadata()) {
        self.success = success
        self.data = data
        self.error = error
        self.metadata = metadata
    }
    
    public static func success(_ data: T) -> ResultModel<T> {
        ResultModel(success: true, data: data)
    }
    
    public static func failure(_ error: ErrorModel) -> ResultModel<T> {
        ResultModel(success: false, error: error)
    }
}
