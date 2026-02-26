//
//  UserLoginView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//
import SwiftUI
import ToastService

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
            RegisterSheet(vm: vm)
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
                        // Campos de texto
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalEmail)
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .roundedTextFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalPassword)
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                SecureField("", text: $password)
                                    .roundedTextFieldStyle()
                            }
                        }

                        // Divisor
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)

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
                }
            }
        }.presentationDragIndicator(.visible)
    }
}

struct RegisterSheet: View {
    @Bindable var vm: UserLoginVM

    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""

    var isValidPassword: Bool {
        password.count >= 8
    }

    var isValidEmail: Bool {
        let regex = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/
        return email.wholeMatch(of: regex) != nil
    }

    var isValidForm: Bool {
        isValidPassword && isValidEmail
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Campos de texto
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalEmail)
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .roundedTextFieldStyle()
                            }
                            Text(.userloginEmailok)
                                .foregroundStyle(
                                    isValidEmail ? .green : .gray
                                )

                            VStack(alignment: .leading, spacing: 8) {
                                Text(.globalPassword)
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                SecureField("", text: $password)
                                    .roundedTextFieldStyle()
                            }
                            Text(.userloginMinchars)
                                .foregroundStyle(
                                    isValidPassword ? .green : .gray
                                )
                        }

                        // Divisor
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)

                        // Botón de registro
                        Button(action: {
                            Task {
                                let result = await vm.createUser(
                                    email: email,
                                    password: password
                                )
                                if result {
                                    dismiss()
                                }
                            }
                        }) {
                            Text(.userLoginButtonSignup)
                        }
                        .buttonStyle(.primary)
                        .disabled(!isValidForm)
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
                }
            }
        }
        .toastOverlay()
        .presentationDragIndicator(.visible)
    }
}

#Preview(traits: .devEnvironment) {
    UserLoginView(vm: UserLoginVM(apiManager: .test))
}
