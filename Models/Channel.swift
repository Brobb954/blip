//
//  Channel.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import FirebaseFirestore
import Foundation

struct Channel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var lastMessagePreview: String?
    @ServerTimestamp var lastActivity: Date?
}
