//
//  blipApp.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import SwiftUI
import Firebase

@main
struct ChatApp: App {
  @StateObject private var authVM = AuthViewModel()

  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      Group {
        if authVM.isSignedIn {
          ChannelsListView()
            .environmentObject(authVM)
        } else {
          LoginView()
            .environmentObject(authVM)
        }
      }
      .accentColor(Color.myAccent)
      .preferredColorScheme(.dark)
      .background(Color.bgPrimary.ignoresSafeArea())
    }
  }
}
