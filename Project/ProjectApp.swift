//
//  ProjectApp.swift
//  Project
//
//  App entry point - Kit Host architecture
//  The app owns UI composition and navigation only.
//  Kits own logic, state, intelligence, and side effects.
//

import SwiftUI
import NavigationKit

@main
struct ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            DoubleSidebarLayoutV2()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1400, height: 900)
        .commands {
            // File commands
            CommandGroup(replacing: .newItem) {
                Button("Open Folder...") {
                    openFolder()
                }
                .keyboardShortcut("o", modifiers: .command)
            }
            
            // View commands
            CommandGroup(after: .sidebar) {
                Button("Show Chat") {
                    NotificationCenter.default.post(name: .showChat, object: nil)
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Show Dashboard") {
                    NotificationCenter.default.post(name: .showDashboard, object: nil)
                }
                .keyboardShortcut("2", modifiers: .command)
                
                Button("Toggle Sidebar") {
                    NotificationCenter.default.post(name: .toggleSidebar, object: nil)
                }
                .keyboardShortcut("s", modifiers: [.command, .control])
                
                Divider()
                
                Button("Show Terminal") {
                    NotificationCenter.default.post(name: .showTerminalPanel, object: nil)
                }
                .keyboardShortcut("t", modifiers: [.command, .shift])
                
                Button("Show Output") {
                    NotificationCenter.default.post(name: .showOutputPanel, object: nil)
                }
                .keyboardShortcut("o", modifiers: [.command, .shift])
                
                Button("Show Problems") {
                    NotificationCenter.default.post(name: .showProblemsPanel, object: nil)
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])
            }
        }
        
        Settings {
            SettingsView()
        }
    }
    
    private func openFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            Task { @MainActor in
                await FlowKitHost.shared.mountDirectory(path: url.path)
            }
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            
            KitsSettingsView()
                .tabItem {
                    Label("Kits", systemImage: "shippingbox")
                }
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 400)
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Show sidebar icons", isOn: .constant(true))
                Toggle("Compact mode", isOn: .constant(false))
            }
            
            Section("Behavior") {
                Toggle("Auto-scan directories", isOn: .constant(true))
                Toggle("Enable AI features", isOn: .constant(true))
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct KitsSettingsView: View {
    var body: some View {
        Form {
            Section("Active Kits") {
                KitRow(name: "CoreKit", version: "1.0.0", enabled: true)
                KitRow(name: "IdeaKit", version: "1.0.0", enabled: true)
                KitRow(name: "IconKit", version: "1.0.0", enabled: true)
                KitRow(name: "ChatKit", version: "1.0.0", enabled: true)
                KitRow(name: "AIKit", version: "1.0.0", enabled: true)
                KitRow(name: "WorkflowKit", version: "1.0.0", enabled: true)
                KitRow(name: "AgentKit", version: "1.0.0", enabled: true)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct KitRow: View {
    let name: String
    let version: String
    let enabled: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(enabled ? .green : .gray)
                .frame(width: 8, height: 8)
            
            Text(name)
            
            Spacer()
            
            Text(version)
                .foregroundStyle(.secondary)
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 64))
                .foregroundStyle(.blue)
            
            Text("FlowKit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Local-first, AI-native Project Operating System")
                .foregroundStyle(.secondary)
            
            Text("Version 2.0.0")
                .font(.caption)
                .foregroundStyle(.tertiary)
            
            Spacer()
            
            Text("35 Kits • 422+ Tests")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(40)
    }
}
