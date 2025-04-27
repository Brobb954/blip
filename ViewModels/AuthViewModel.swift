//
//  AuthViewModel.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import FirebaseAuth
import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.isSignedIn = (user != nil)
        }
    }

    deinit {
        if let h = handle {
            Auth.auth().removeStateDidChangeListener(h)
        }
    }

    func signIn() {
        Task {
            do {
                try await Auth.auth()
                    .signIn(withEmail: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func signUp() {
        Task {
            do {
                try await Auth.auth()
                    .createUser(withEmail: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func signOut() {
        Task {
            do {
                try Auth.auth().signOut()
                isSignedIn = false
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
