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

    var body: some View {
        NavigationStack {
            List {
                // Sección de perfil superior
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            CircleAvatar()
                                .frame(width: 80, height: 80)

                            Text(vm.userEmail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 20)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                // Opciones de configuración
                Section {
                    NavigationLink {
                        Text("Información Personal")
                    } label: {
                        Label(
                            "Información Personal",
                            systemImage: "person.fill"
                        )
                    }

                    NavigationLink {
                        Text("Privacidad")
                    } label: {
                        Label("Privacidad", systemImage: "lock.fill")
                    }

                    NavigationLink {
                        Text("Notificaciones")
                    } label: {
                        Label("Notificaciones", systemImage: "bell.fill")
                    }
                }

                Section {
                    NavigationLink {
                        Text("Ayuda y Soporte")
                    } label: {
                        Label(
                            "Ayuda y Soporte",
                            systemImage: "questionmark.circle.fill"
                        )
                    }

                    NavigationLink {
                        Text("Acerca de")
                    } label: {
                        Label("Acerca de", systemImage: "info.circle.fill")
                    }
                }

                // Botón de cerrar sesión
                Section {
                    Button(action: {
                        authStatus.isLoggedIn = vm.logOut()
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
        }
        .toolbar(.hidden, for: .tabBar)
        .listStyle(.sidebar)
        .globalBackground()
    }
}

#Preview(traits: .devEnvironment) {
    UserAcountView(vm: UserAccountVM())
}
