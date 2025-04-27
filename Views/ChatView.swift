//
//  ChatView.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import SwiftUI

struct ChatView: View {
    let channel: Channel
    @StateObject private var vm: ChatViewModel

    init(channel: Channel) {
        self.channel = channel
        _vm = StateObject(
            wrappedValue: ChatViewModel(
                channelID: channel.id ?? ""
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(vm.messages) { msg in
                            MessageBubbleView(message: msg)
                                .id(msg.id)
                        }
                    }
                }
                .background(Color.bgPrimary)
                .onChange(of: vm.messages.count) {
                    if let last = vm.messages.last?.id {
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                }
            }

            HStack {
                TextField("Message…", text: $vm.input)
                    .textFieldStyle(.roundedBorder)
                Button {
                    vm.send()
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .tint(Color.myAccent)
            }
            .padding()
            .background(Color.bgSecondary)
        }
        .navigationTitle(channel.name)
        .background(Color.bgPrimary.ignoresSafeArea())
    }
}
