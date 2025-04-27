//
//  ChannelsViewModel.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import FirebaseDatabase
import Foundation

@MainActor
final class ChannelsViewModel: ObservableObject {
    @Published var channels: [Channel] = []
    @Published var newName = ""
    @Published var showingNew = false

    private var handle: DatabaseHandle?

    init() {
        handle = RTDBService.shared.observeChannels { [weak self] list in
            self?.channels = list
        }
    }

    deinit {
        if let h = handle {
            RTDBService.shared.removeChannelsObserver(h)
        }
    }

    func create() {
        let name = newName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        RTDBService.shared.createChannel(name: name)
        newName = ""
    }

    func delete(at offsets: IndexSet) {
        for i in offsets {
            let channel = channels[i]
            if let id = channel.id {
                RTDBService.shared.deleteChannel(id)
            }
        }
        channels.remove(atOffsets: offsets)
    }
}
