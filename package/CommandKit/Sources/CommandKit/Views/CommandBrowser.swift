//
//  CommandBrowser.swift
//  CommandKit
//

import SwiftUI

public struct CommandBrowser: View {
    @StateObject private var viewModel = CommandViewModel()
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
                ForEach(CommandSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Categories") {
                ForEach(CommandCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
        }
        .navigationTitle("Commands")
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewMode {
        case .list:
            CommandList(viewModel: viewModel)
        case .table:
            CommandTable(viewModel: viewModel)
        case .gallery:
            CommandGallery(viewModel: viewModel)
        }
    }
    
    enum ViewMode: String, CaseIterable {
        case list, table, gallery
        
        var icon: String {
            switch self {
            case .list: return "list.bullet"
            case .table: return "tablecells"
            case .gallery: return "square.grid.2x2"
            }
        }
    }
}
