//
//  LoginView.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var isLogin = true

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome")
                    .font(.largeTitle)
                    .foregroundStyle(Color.txtPrimary)

                Picker("", selection: $isLogin) {
                    Text("Log In").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                TextField("Email", text: $auth.email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Password", text: $auth.password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                if let err = auth.errorMessage {
                    Text(err)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                Button(isLogin ? "Log In" : "Sign Up") {
                    isLogin ? auth.signIn() : auth.signUp()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 50)
            .background(Color.bgPrimary.ignoresSafeArea())
            .navigationTitle(isLogin ? "Log In" : "Sign Up")
        }
    }
}
