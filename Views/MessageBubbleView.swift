//
//  MessageBubbleView.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import FirebaseAuth
import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage

    private var isMe: Bool {
        message.senderID == Auth.auth().currentUser?.uid
    }

    private func formattedTime(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "h:mm a"
        return fmt.string(from: date)
    }

    var body: some View {
        VStack(alignment: isMe ? .trailing : .leading, spacing: 4) {
            if let name = message.senderName, !name.isEmpty {
                Text(name)
                    .font(.caption2)
                    .foregroundStyle(Color.txtSecondary)
            }
            HStack {
                if isMe { Spacer() }
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.text)
                        .padding(10)
                        .foregroundStyle(Color.txtPrimary)
                        .background(
                            isMe
                                ? Color.bubbleUser
                                : Color.bubbleAssistant
                        )
                        .cornerRadius(12)
                    Text(formattedTime(message.timestamp))
                        .font(.caption2)
                        .foregroundStyle(Color.txtSecondary)
                        .padding(
                            isMe
                                ? .trailing
                                : .leading,
                            12
                        )
                }
                if !isMe { Spacer() }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
