//
//  AppEnvironmentModifier.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 24/1/26.
//

import SwiftUI

#if DEBUG
struct AppEnvironmentModifier: PreviewModifier {
    struct Context {
        let authStatus: AuthStatus
        let mainTabVM: MainTabVM
    }

    static func makeSharedContext() async throws -> Context {
        let auth = AuthStatus(apiManager: .test)
        let tabs = MainTabVM()
        
        return Context(authStatus: auth, mainTabVM: tabs)
    }

    func body(content: Content, context: Context) -> some View {
        content
            .environment(context.authStatus)
            .environment(context.mainTabVM)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    /// Inyecta AuthStatus y MainTabVM simulados.
    static var devEnvironment: Self = .modifier(AppEnvironmentModifier())
}
#endif
