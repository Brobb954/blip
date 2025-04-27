//
//  ChannelRowView.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import SwiftUI

struct ChannelRowView: View {
    let channel: Channel

    var body: some View {
        HStack {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .tint(Color.myAccent)
            VStack(alignment: .leading) {
                Text(channel.name)
                    .font(.headline)
                    .foregroundStyle(Color.txtPrimary)
                if let p = channel.lastMessagePreview {
                    Text(p)
                        .font(.subheadline)
                        .foregroundStyle(Color.txtSecondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
