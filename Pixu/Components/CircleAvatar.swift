//
//  Avatar.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import SwiftUI

struct CircleAvatar: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .overlay(
                Text("U")  // TODO: inicial del usuario
                    .font(.title2)
                    .foregroundColor(.primary)
                    .bold()
            )
    }
}
#Preview {
    CircleAvatar()
}
