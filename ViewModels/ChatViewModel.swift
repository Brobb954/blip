//
//  ChatViewModel.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var input = ""

    private let channelID: String
    private var handle: DatabaseHandle?

    init(channelID: String) {
        self.channelID = channelID
        handle = RTDBService.shared.observeMessages(
            channelID: channelID
        ) { [weak self] msg in
            self?.messages.append(msg)
        }
    }

    deinit {
        if let h = handle {
            RTDBService.shared.removeMessagesObserver(
                channelID: channelID,
                handle: h
            )
        }
    }

    func send() {
        let text = input.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty,
            let uid = Auth.auth().currentUser?.uid
        else { return }

        // 1) Look up the displayName for this uid
        RTDBService.shared.getUserDisplayName(uid: uid) { name in
            // 2) Build the message including senderID + senderName
            let msg = ChatMessage(
                id: UUID().uuidString,
                text: text,
                role: .user,
                timestamp: Date(),
                senderID: uid,
                senderName: name
            )

            // 3) Send it
            RTDBService.shared.sendMessage(msg, in: self.channelID)

            // 4) Clear the input on the main thread
            DispatchQueue.main.async {
                self.input = ""
            }
        }
    }
}
