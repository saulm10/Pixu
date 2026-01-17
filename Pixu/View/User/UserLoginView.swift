//
//  UserLoginView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//
import SwiftUI

struct UserLoginView: View {
    @Bindable var vm: UserLoginVM

    @State private var showLogin = false
    @State private var showRegister = false
    var body: some View {

        ZStack {
            VStack(spacing: 40) {
                Spacer()

                // Logo
                Image(.pixieHi)
                    .resizable()
                    .scaledToFit()
                    .padding()

                VStack(spacing: 16) {
                    // Texto principal
                    Text(.userLoginTitle)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .bold()

                    // Texto secundario
                    Text(.userLoginSubtitle)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                // Botones
                VStack(spacing: 16) {
                    Button(action: { showLogin = true }) {
                        Text(.userLoginButtonLogin)
                    }.buttonStyle(.primary)

                    Button(action: { showRegister = true }) {
                        Text(.userLoginButtonSignup)
                    }.buttonStyle(.secondary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginSheet(vm: vm)
        }
        .sheet(isPresented: $showRegister) {
            RegisterSheet()
        }
        .globalBackground()
    }
}

struct LoginSheet: View {
    @Environment(AuthStatus.self) private var authStatus

    @Bindable var vm: UserLoginVM
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Botones sociales
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                        .font(.title2)
                                    Text(.globalContinueGoogle)
                                        .font(.headline)
                                }
                            }.buttonStyle(.tertiary)

                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "apple.logo")
                                        .font(.title2)
                                    Text(.globalContinueApple)
                                        .font(.headline)
                                }
                            }.buttonStyle(.tertiary)
                        }

                        // Divisor
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            Text(verbatim: "o")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)

                        // Campos de texto
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalEmail)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .roundedTextFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalPassword)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                SecureField("", text: $password)
                                    .roundedTextFieldStyle()
                            }
                        }

                        // Botón de iniciar sesión
                        Button(
                            action: {
                                Task {
                                    authStatus.isLoggedIn = await vm.login(
                                        email: email,
                                        password: password
                                    )
                                }
                            }
                        ) {
                            Text(.userLoginButtonLogin)

                        }.buttonStyle(.primary)
                    }
                    .padding(24)
                }
            }
            .navigationTitle(.userLoginButtonLogin)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(.globalClose) {
                        dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
}

struct RegisterSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""

    var isValidPassword: Bool {
        password.count >= 8
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Botones sociales
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                        .font(.title2)
                                    Text(.globalContinueGoogle)
                                        .font(.headline)
                                }
                            }.buttonStyle(.tertiary)

                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "apple.logo")
                                        .font(.title2)
                                    Text(.globalContinueApple)
                                        .font(.headline)
                                }
                            }.buttonStyle(.tertiary)
                        }

                        // Divisor
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            Text(verbatim: "o")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)

                        // Campos de texto
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalEmail)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .roundedTextFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalPassword)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                SecureField("", text: $password)
                                    .roundedTextFieldStyle()
                            }
                            Text("Mínimo 8 caracteres")
                                .foregroundColor(
                                    password.count >= 8 ? .green : .gray
                                )
                        }

                        // Botón de registro
                        Button(action: {}) {
                            Text(.userLoginButtonSignup)

                        }.buttonStyle(.primary)
                            .disabled(!isValidPassword)
                    }
                    .padding(24)
                }
            }
            .navigationTitle(.userLoginButtonSignup)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(.globalClose) {
                        dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
}

#Preview {
    var authStatus = AuthStatus()

    UserLoginView(vm: UserLoginVM(apiManager: .test))
        .environment(authStatus)
}
