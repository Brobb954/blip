//
//  ProfileViewModel.swift
//  blip
//
//  Created by Brandon Robb on 4/27/25.
//

import FirebaseAuth
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName = ""
    @Published var errorMessage: String?

    init() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        RTDBService.shared.getUserDisplayName(uid: uid) { name in
            DispatchQueue.main.async {
                self.displayName = name ?? ""
            }
        }
    }

    func save() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        RTDBService.shared.setUserDisplayName(
            uid: uid,
            name: displayName
        )
    }
}
