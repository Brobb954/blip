//
//  ChatMessage.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import Foundation

enum MessageRole: String, Codable {
    case user, assistant
}

struct ChatMessage: Identifiable, Codable {
    var id: String
    var text: String
    var role: MessageRole
    var timestamp: Date
    var senderID: String
    var senderName: String?
}
