//
//  PixuApp.swift
//  Pixu
//

import SwiftData
import SwiftUI

@main
struct PixuApp: App {
    @State private var authStatus = AuthStatus()
    let database = DatabaseManager.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(authStatus)
        }
        .modelContainer(database.modelContainer)
    }
}
