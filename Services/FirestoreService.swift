//
//  FirestoreService.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import FirebaseFirestore
import Foundation

final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()

    private init() {}

    func fetchChannels() async throws -> [Channel] {
        let snap = try await db.collection("channels")
            .order(by: "lastActivity", descending: true)
            .getDocuments()
        return try snap.documents.compactMap {
            try $0.data(as: Channel.self)
        }
    }

    func createChannel(name: String) async throws -> Channel {
        let ref = db.collection("channels").document()
        let channel = Channel(
            id: ref.documentID,
            name: name,
            lastMessagePreview: nil,
            lastActivity: nil
        )
        try ref.setData(from: channel)
        return channel
    }

    func listenMessages(
        in channelID: String,
        _ onUpdate: @escaping ([ChatMessage]) -> Void
    ) -> ListenerRegistration {
        let ref = db.collection("channels")
            .document(channelID)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        return ref.addSnapshotListener { snap, err in
            guard let docs = snap?.documents else { return }
            let msgs = docs.compactMap {
                try? $0.data(as: ChatMessage.self)
            }
            onUpdate(msgs)
        }
    }

    func sendMessage(
        _ message: ChatMessage,
        in channelID: String
    ) {
        let ref = db.collection("channels")
            .document(channelID)
            .collection("messages")
            .document(message.id)
        do {
            try ref.setData(from: message)
            db.collection("channels").document(channelID)
                .updateData([
                    "lastMessagePreview": message.text,
                    "lastActivity": FieldValue.serverTimestamp(),
                ])
        } catch {
            print("Firestore write error:", error)
        }
    }
}
