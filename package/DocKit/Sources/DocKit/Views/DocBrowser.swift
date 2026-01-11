//
//  DocBrowser.swift
//  DocKit
//

import SwiftUI

public struct DocBrowser: View {
    @StateObject private var viewModel = DocViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            DocList(viewModel: viewModel)
        }
    }
    
    private var sidebar: some View {
        List(selection: $viewModel.selectedSection) {
            Section("Sections") {
                ForEach(DocSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Categories") {
                ForEach(DocCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
        }
        .navigationTitle("Documents")
    }
}
