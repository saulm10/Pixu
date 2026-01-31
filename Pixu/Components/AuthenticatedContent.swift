//
//  AuthenticatedContent.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 25/1/26.
//

import SwiftUI

struct AuthenticatedContentModifier: ViewModifier {
    @Environment(AuthStatus.self) private var auth
    @Environment(MainTabVM.self) private var main
    
    func body(content: Content) -> some View {
        if auth.isLoggedIn {
            content
        } else {
            Button("Inicia sesión para interactuar") {
                main.selection = 2
            }
            .buttonStyle(.borderedProminent)
            .tint(.gray)
        }
    }
}

extension View {
    func requiresAuthentication() -> some View {
        self.modifier(AuthenticatedContentModifier())
    }
}
