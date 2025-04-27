//
//  ProfileView.swift
//  blip
//
//  Created by Brandon Robb on 4/27/25.
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var vm = ProfileViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section("Display Name") {
                    TextField("Your name", text: $vm.displayName)
                }
                Section {
                    Button("Save") {
                        vm.save()
                        dismiss()
                    }
                }
                Section {
                    Button("Sign Out", role: .destructive) {
                        authVM.signOut()
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarItems(
                trailing:
                    Button("Done") { dismiss() }
            )
        }
    }
}
