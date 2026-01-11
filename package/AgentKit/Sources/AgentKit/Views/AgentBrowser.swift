//
//  AgentBrowser.swift
//  AgentKit
//

import SwiftUI

public struct AgentBrowser: View {
    @StateObject private var viewModel = AgentViewModel()
    @State private var viewMode: ViewMode = .list
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            content
        }
        .toolbar {
            ToolbarItemGroup {
                Picker("View", selection: $viewMode) {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Image(systemName: mode.icon)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
    
    private var sidebar: some View {
        List(selection: $viewModel.selectedSection) {
            Section("Sections") {
                ForEach(AgentSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Categories") {
                ForEach(AgentCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
        }
        .navigationTitle("Agents")
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewMode {
        case .list:
            AgentList(viewModel: viewModel)
        case .gallery:
            AgentGallery(viewModel: viewModel)
        }
    }
    
    enum ViewMode: String, CaseIterable {
        case list, gallery
        
        var icon: String {
            switch self {
            case .list: return "list.bullet"
            case .gallery: return "square.grid.2x2"
            }
        }
    }
}
