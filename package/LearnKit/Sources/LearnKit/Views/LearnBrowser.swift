//
//  LearnBrowser.swift
//  LearnKit
//

import SwiftUI

public struct LearnBrowser: View {
    @StateObject private var viewModel = LearnViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            LearnList(viewModel: viewModel)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search lessons...")
    }
    
    private var sidebar: some View {
        List(selection: $viewModel.selectedSection) {
            Section("Sections") {
                ForEach(LearnSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Categories") {
                ForEach(LessonCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
        }
        .navigationTitle("Learn")
    }
}
