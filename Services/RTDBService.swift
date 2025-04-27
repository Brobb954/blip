//
//  RTDBService.swift
//  blip
//
//  Created by Brandon Robb on 4/26/25.
//

import FirebaseDatabase
import Foundation

final class RTDBService {
    static let shared = RTDBService()
    private let root = Database.database().reference()

    private init() {}

    func observeChannels(
        _ onUpdate: @escaping ([Channel]) -> Void
    ) -> DatabaseHandle {
        let ref = root.child("channels")
        return ref.observe(
            .value,
            with: { snap in
                var result: [Channel] = []
                for case let child as DataSnapshot in snap.children {
                    guard
                        let dict = child.value as? [String: Any],
                        let name = dict["name"] as? String,
                        let rawTs = dict["lastActivity"] as? TimeInterval
                    else { continue }
                    let channel = Channel(
                        id: child.key,
                        name: name,
                        lastMessagePreview: dict["lastMessagePreview"]
                            as? String,
                        lastActivity: Date(timeIntervalSince1970: rawTs)
                    )
                    result.append(channel)
                }
                onUpdate(
                    result.sorted {
                        ($0.lastActivity ?? .distantPast)
                            > ($1.lastActivity ?? .distantPast)
                    }
                )
            }
        )
    }

    func removeChannelsObserver(_ handle: DatabaseHandle) {
        root.child("channels")
            .removeObserver(withHandle: handle)
    }

    func createChannel(name: String) {
        let ref = root.child("channels").childByAutoId()
        let now = Date().timeIntervalSince1970
        let data: [String: Any] = [
            "name": name,
            "lastMessagePreview": "",
            "lastActivity": now,
        ]
        ref.setValue(data)
    }

    func deleteChannel(_ channelID: String) {
        root.child("channels").child(channelID).removeValue()
        root.child("messages").child(channelID).removeValue()
    }

    func observeMessages(
        channelID: String,
        onNewMessage: @escaping (ChatMessage) -> Void
    ) -> DatabaseHandle {
        let ref = root.child("messages").child(channelID)
        return ref.observe(
            .childAdded,
            with: { snap in
                guard
                    let dict = snap.value as? [String: Any],
                    let text = dict["text"] as? String,
                    let roleRaw = dict["role"] as? String,
                    let role = MessageRole(rawValue: roleRaw),
                    let ts = dict["timestamp"] as? TimeInterval,
                    let senderID = dict["senderID"] as? String
                else { return }

                let msg = ChatMessage(
                    id: snap.key,
                    text: text,
                    role: role,
                    timestamp: Date(timeIntervalSince1970: ts),
                    senderID: senderID,
                    senderName: dict["senderName"] as? String
                )
                onNewMessage(msg)
            }
        )
    }

    func removeMessagesObserver(
        channelID: String,
        handle: DatabaseHandle
    ) {
        root.child("messages")
            .child(channelID)
            .removeObserver(withHandle: handle)
    }

    func sendMessage(
        _ message: ChatMessage,
        in channelID: String
    ) {
        let ref = root.child("messages")
            .child(channelID)
            .childByAutoId()
        let now = message.timestamp.timeIntervalSince1970
        let data: [String: Any] = [
            "text": message.text,
            "role": message.role.rawValue,
            "timestamp": now,
            "senderID": message.senderID,
            "senderName": message.senderName ?? "",
        ]
        ref.setValue(data)
        root.child("channels").child(channelID)
            .updateChildValues([
                "lastMessagePreview": message.text,
                "lastActivity": now,
            ])
    }

    func getUserDisplayName(
        uid: String,
        completion: @escaping (String?) -> Void
    ) {
        root.child("users")
            .child(uid)
            .child("displayName")
            .observeSingleEvent(of: .value) { snap in
                completion(snap.value as? String)
            }
    }

    func setUserDisplayName(uid: String, name: String) {
        root.child("users")
            .child(uid)
            .child("displayName")
            .setValue(name)
    }
}
