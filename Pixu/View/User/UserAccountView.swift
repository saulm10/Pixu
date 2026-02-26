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
    @AppStorage(UserDefaultsK.showAdultContent.rawValue) var showAdultContent:
        Bool = false
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
            .capitalized ?? "-"
    }

    var body: some View {
        NavigationStack {
            List {
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
                                .useraccountRemoveicon,
                                systemImage: "person.crop.circle.badge.xmark"
                            )
                        }
                    }
                }

                Section(.useraccountPreferences) {
                    HStack {
                        Label(.useraccountApplanguaje, systemImage: "globe")
                        Spacer()
                        Text(currentLanguage)
                            .foregroundStyle(.secondary)
                    }

                    Toggle(isOn: $showAdultContent) {
                        Label(.useraccountAdultcontent, systemImage: "eye.fill")
                    }
                }

                if authStatus.isLoggedIn {
                    Section(.useraccountData) {
                        Button(role: .destructive) {
                            showDeleteCollectionAlert = true
                        } label: {
                            Label(
                                .useraccountDeletecollection,
                                systemImage: "trash.fill"
                            )
                        }
                    }
                }

                Section(.useraccountAbout) {
                    HStack {
                        Label(
                            .useraccountVersion,
                            systemImage: "info.circle.fill"
                        )
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }

                if authStatus.isLoggedIn {
                    Section {
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            HStack {
                                Spacer()
                                Text(.useraccountLogout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(.useraccountTitle)
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                .useraccountAlerDeletecollection,
                isPresented: $showDeleteCollectionAlert
            ) {
                Button(.globalClose, role: .cancel) {}
                Button(.useraccountAlerDeletecollectionok, role: .destructive) {
                    Task {
                        await vm.deleteAllCollection()
                    }
                }
            } message: {
                Text(
                    .useraccountAlerDeletecollectionmesage
                )
            }
            .alert(.useraccountAlerLogout, isPresented: $showLogoutAlert) {
                Button(.globalClose, role: .cancel) {}
                Button(.useraccountAlerLogoutok, role: .destructive) {
                    authStatus.isLoggedIn = vm.logOut()
                }
            } message: {
                Text(
                    .useraccountAlerLogoutmesage
                )
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
