//
//  AppEnvironmentModifier.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 24/1/26.
//

import SwiftData
import SwiftUI
import ToastService

#if DEBUG
    struct AppEnvironmentModifier: PreviewModifier {
        struct Context {
            let authStatus: AuthStatus
            let mainTabVM: MainTabVM
            let previewContainer: ModelContainer
        }

        @MainActor
        static func makeSharedContext() async throws -> Context {
            let auth = AuthStatus(apiManager: .test)
            let tabs = MainTabVM()

            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: UserCollection.self,
                Manga.self,
                configurations: config
            )

            return Context(
                authStatus: auth,
                mainTabVM: tabs,
                previewContainer: container
            )
        }

        func body(content: Content, context: Context) -> some View {
            content
                .environment(context.authStatus)
                .environment(context.mainTabVM)
                .modelContainer(context.previewContainer)
                .toastOverlay()
        }
    }

    extension PreviewTrait where T == Preview.ViewTraits {
        static var devEnvironment: Self = .modifier(AppEnvironmentModifier())
    }

    struct AppEnvironmentModifierNoLogin: PreviewModifier {
        struct Context {
            let authStatus: AuthStatus
            let mainTabVM: MainTabVM
        }

        static func makeSharedContext() async throws -> Context {
            let auth = AuthStatus(apiManager: .test)
            let tabs = MainTabVM()

            auth.isLoggedIn = false

            return Context(authStatus: auth, mainTabVM: tabs)
        }

        func body(content: Content, context: Context) -> some View {
            let database = DatabaseManager.shared

            content
                .environment(context.authStatus)
                .environment(context.mainTabVM)
                .modelContainer(database.modelContainer)
                .toastOverlay()
        }
    }

    extension PreviewTrait where T == Preview.ViewTraits {
        static var devEnvironmentNoLogin: Self = .modifier(
            AppEnvironmentModifierNoLogin()
        )
    }
#endif
