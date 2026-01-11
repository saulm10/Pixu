//
//  PixuApp.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 29/12/25.
//

import SwiftUI

@main
struct PixuApp: App {
    @State private var authStatus = AuthStatus()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }.environment(authStatus)
    }
}
