//
//  TextFieldsStyles.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 10/1/26.
//

import SwiftUI


struct RoundedTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 1.5)
            )
            .cornerRadius(18)
    }
}

// Versión con estado de focus
struct FocusableTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .frame(height: 46)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isFocused ? Color.accentColor : Color.primary.opacity(0.3),
                        lineWidth: isFocused ? 2 : 1.5
                    )
            )
            .cornerRadius(18)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// Versión con placeholder personalizado
struct PlaceholderTextFieldStyle: TextFieldStyle {
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
            }
            
            configuration
                .padding()
                .frame(height: 46)
        }
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    isFocused ? Color.accentColor : Color.primary.opacity(0.3),
                    lineWidth: isFocused ? 2 : 1.5
                )
        )
        .cornerRadius(18)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Extensión para acceso fácil

extension TextFieldStyle where Self == RoundedTextFieldStyle {
    static var rounded: RoundedTextFieldStyle {
        RoundedTextFieldStyle()
    }
}

extension TextFieldStyle where Self == FocusableTextFieldStyle {
    static var focusable: FocusableTextFieldStyle {
        FocusableTextFieldStyle()
    }
}

// MARK: - View Modifier alternativo (más flexible)

struct RoundedTextFieldModifier: ViewModifier {
    let isFocused: Bool

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 46)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isFocused ? Color.accentColor : Color.primary.opacity(0.3),
                        lineWidth: isFocused ? 2 : 1.5
                    )
            )
            .cornerRadius(18)
    }
}


extension View {
    func roundedTextFieldStyle(isFocused: Bool = false) -> some View {
        modifier(RoundedTextFieldModifier(isFocused: isFocused))
    }
}
