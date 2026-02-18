//
//  UserAcountView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import SwiftUI

struct UserAcountView: View {
    @Bindable var vm: UserAccountVM
    @Environment(AuthStatus.self) private var authStatus

    @AppStorage(UserDefaultsK.login.rawValue) var login: String = ""
    @AppStorage(UserDefaultsK.image.rawValue) var image: String = ""

    @State private var showDeleteCollectionAlert = false
    @State private var showLogoutAlert = false

    private var appVersion: String {
        let version =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "1.0"
        let build =
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private var currentLanguage: String {
        let locale = Locale.current
        return locale.localizedString(forIdentifier: locale.identifier)?
            .capitalized ?? "Desconocido"
    }

    var body: some View {
        NavigationStack {
            List {
                // SECCIÓN 1: Perfil de Usuario
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            CircleAvatar(big: true)

                            Text(login)
                                .font(.title3)
                                .bold()
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                    if !image.isEmpty {
                        Button(role: .destructive) {
                            image = ""
                        } label: {
                            Label(
                                "Quitar icono de perfil",
                                systemImage: "person.crop.circle.badge.xmark"
                            )
                        }
                    }
                }

                // SECCIÓN 2: Preferencias de la App
                Section("Preferencias") {
                    // Idioma (Informativo)
                    HStack {
                        Label("Idioma de la aplicación", systemImage: "globe")
                        Spacer()
                        Text(currentLanguage)
                            .foregroundStyle(.secondary)
                    }
                }

                // SECCIÓN 3: Gestión de Datos
                Section("Datos") {
                    Button(role: .destructive) {
                        showDeleteCollectionAlert = true
                    } label: {
                        Label(
                            "Borrar toda mi colección",
                            systemImage: "trash.fill"
                        )
                    }
                }

                // SECCIÓN 4: Información de la App
                Section("Acerca de Pixu") {
                    HStack {
                        Label("Versión", systemImage: "info.circle.fill")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }

                // SECCIÓN 5: Zona de Peligro (Cerrar Sesión)
                Section {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Cerrar Sesión")
                                .fontWeight(.semibold)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .alert("¿Borrar colección?", isPresented: $showDeleteCollectionAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Borrar", role: .destructive) {
                    // TODO: Llama a la función de tu ViewModel para borrar de SwiftData
                    // vm.deleteAllUserCollection()
                }
            } message: {
                Text("Esta acción eliminará todos los mangas de tu colección. No se puede deshacer.")
            }
            .alert("¿Cerrar sesión?", isPresented: $showLogoutAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Cerrar sesión", role: .destructive) {
                    authStatus.isLoggedIn = vm.logOut()
                }
            } message: {
                Text("Se cerrará tu sesión actual y volverás a la pantalla de inicio.")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .globalBackground()
    }
}

#Preview(traits: .devEnvironment) {
    UserAcountView(vm: UserAccountVM())
}
