//
//  PixuApp.swift
//  Pixu
//

import SwiftData
import SwiftUI

@main
struct PixuApp: App {
    @State private var authStatus = AuthStatus()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .environment(authStatus)
        .modelContainer(for: [Collection.self, Manga.self]) { result in
            guard case .success(let container) = result else {
                print("Error al crear el contenedor de SwiftData")
                return
            }

            Task.detached(priority: .high) {
                let dataContainer = DataContainer(modelContainer: container)

                do {
                    let isAuthenticated = await authStatus.isLoggedIn
                    try await dataContainer.loadInitialData(
                        isAuthenticated: isAuthenticated
                    )
                } catch {
                    print("Error cargando datos iniciales: \(error)")
                }
            }
        }
//        .onChange(of: authStatus.isLoggedIn) { oldValue, newValue in
//            if !newValue {
//                Task {
//                    let container = try? await modelContainer(for: [
//                        Collection.self, Manga.self,
//                    ])
//                    if let container {
//                        let dataContainer = DataContainer(
//                            modelContainer: container
//                        )
//                        try? await dataContainer.clearAllData()
//                    }
//                }
//            }
//        }
    }
}
