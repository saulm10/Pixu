//
//  AppEnvironmentModifier.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 24/1/26.
//

import SwiftUI
import ToastService

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
                
        return Context(authStatus: auth, mainTabVM: tabs)
    }

    func body(content: Content, context: Context) -> some View {
        
        content
            .environment(context.authStatus)
            .environment(context.mainTabVM)
            .toastOverlay()
    }
}


extension PreviewTrait where T == Preview.ViewTraits {
    static var devEnvironmentNoLogin: Self = .modifier(AppEnvironmentModifierNoLogin())
}
#endif
