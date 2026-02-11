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
            AuthPromptCard(onTap: {
                main.selection = 2
            })
        }
    }
}

private struct AuthPromptCard: View {
    let onTap: () -> Void

    var body: some View {
        Image(.backResource)
            .resizable()
            .frame(height: 150)
            .overlay {
                HStack(spacing: 16) {
                    // Contenido: texto y botón
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Inicia sesión")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(
                                "Crea una cuenta o inicia sesión para empezar"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        }

                        Button(action: onTap) {
                            Text("Comenzar")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(.primary)

                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .glassEffect(
                in: RoundedRectangle(cornerRadius: 16)
            )
    }
}

extension View {
    func requiresAuthentication() -> some View {
        self.modifier(AuthenticatedContentModifier())
    }
}

#Preview {
    AuthPromptCard(onTap: {})
        .padding()
}
