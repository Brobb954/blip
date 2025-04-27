//
//  ChannelsListView.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import SwiftUI

struct ChannelsListView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var vm = ChannelsViewModel()
    @State private var showingNew = false
    @State private var showingProfile = false

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.channels) { channel in
                    NavigationLink(destination: ChatView(channel: channel)) {
                        ChannelRowView(channel: channel)
                    }
                    .listRowBackground(Color.bgSecondary)
                }
                .onDelete(perform: vm.delete)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.bgPrimary)
            .navigationTitle("Channels")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingNew = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(Color.accent)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    .tint(Color.accent)
                }
            }
            .sheet(isPresented: $showingNew) {
                NavigationView {
                    VStack(spacing: 16) {
                        TextField("Channel Name", text: $vm.newName)
                            .textFieldStyle(.roundedBorder)
                            .padding()

                        Button("Create") {
                            vm.create()
                            showingNew = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)

                        Spacer()
                    }
                    .navigationTitle("New Channel")
                    .background(Color.bgPrimary.ignoresSafeArea())
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingNew = false }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
                    .environmentObject(authVM)
            }
        }
    }
}
