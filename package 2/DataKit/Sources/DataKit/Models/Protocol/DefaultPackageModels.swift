//
//  DefaultPackageModels.swift
//  DataKit
//

import Foundation

/// Default implementation using universal models
public struct DefaultPackageModels: FlowKitPackageModels {
    public typealias Package = PackageModel
    public typealias Category = PackageCategory
    public typealias Node = NodeModel
    public typealias Action = ActionModel
    public typealias Result = ResultModel<AnyCodable>
    public typealias Error = ErrorModel
    public typealias State = StateModel
    public typealias Event = EventModel
}
