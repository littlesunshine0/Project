//
//  ChatCard.swift
//  ChatKit
//
//  Reusable Chat card components
//

import SwiftUI

// MARK: - Conversation Card

public struct ConversationCard: View {
    public let conversation: Conversation
    public var onSelect: (() -> Void)?
    public var onDelete: (() -> Void)?
    public var isActive: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        conversation: Conversation,
        isActive: Bool = false,
        onSelect: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.conversation = conversation
        self.isActive = isActive
        self.onSelect = onSelect
        self.onDelete = onDelete
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.purple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.title ?? "New Conversation")
                        .font(.headline)
                        .foregroundStyle(primaryTextColor)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text("\(conversation.messages.count) messages")
                            .font(.caption)
                            .foregroundStyle(secondaryTextColor)
                        
                        Text("•")
                            .foregroundStyle(secondaryTextColor)
                        
                        Text(conversation.createdAt, style: .relative)
                            .font(.caption)
                            .foregroundStyle(secondaryTextColor)
                    }
                }
                
                Spacer()
                
                if isActive {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                }
                
                if let onDelete = onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isActive ? Color.purple.opacity(0.1) : cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(isActive ? Color.purple.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
    }
    
    private var cardBackground: Color {
        colorScheme == .dark ? Color(white: 0.15) : Color.white
    }
}

// MARK: - Message Card

public struct MessageCard: View {
    public let message: ChatMessage
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(message: ChatMessage) {
        self.message = message
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(avatarColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: avatarIcon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(avatarColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(roleName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(avatarColor)
                    
                    Spacer()
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundStyle(secondaryTextColor)
                }
                
                Text(message.content)
                    .font(.body)
                    .foregroundStyle(primaryTextColor)
            }
        }
        .padding(12)
        .background(messageBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var avatarColor: Color {
        switch message.role {
        case .user: return .blue
        case .assistant: return .purple
        case .system: return .gray
        }
    }
    
    private var avatarIcon: String {
        switch message.role {
        case .user: return "person.fill"
        case .assistant: return "cpu"
        case .system: return "gearshape"
        }
    }
    
    private var roleName: String {
        switch message.role {
        case .user: return "You"
        case .assistant: return "Assistant"
        case .system: return "System"
        }
    }
    
    private var messageBackground: some ShapeStyle {
        switch message.role {
        case .user:
            return colorScheme == .dark ? Color.blue.opacity(0.15) : Color.blue.opacity(0.08)
        case .assistant:
            return colorScheme == .dark ? Color(white: 0.15) : Color.white
        case .system:
            return colorScheme == .dark ? Color.gray.opacity(0.15) : Color.gray.opacity(0.08)
        }
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5)
    }
}

// MARK: - Chat Template Card

public struct ChatTemplateCard: View {
    public let template: ChatTemplate
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(template: ChatTemplate, onSelect: (() -> Void)? = nil) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: template.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.purple)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(template.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Text(template.description)
                        .font(.caption)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3))
            }
            .padding(12)
            .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Chat Cards") {
    VStack(spacing: 16) {
        ConversationCard(
            conversation: Conversation(
                title: "Project Discussion",
                messages: [
                    ChatMessage(content: "Hello!", role: .user),
                    ChatMessage(content: "Hi there!", role: .assistant)
                ]
            ),
            isActive: true,
            onSelect: {},
            onDelete: {}
        )
        
        MessageCard(
            message: ChatMessage(content: "How can I help you today?", role: .assistant)
        )
        
        ChatTemplateCard(
            template: ChatTemplate.builtInTemplates[0],
            onSelect: {}
        )
    }
    .padding()
    .frame(width: 400)
}
