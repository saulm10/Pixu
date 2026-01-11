//
//  GlobalBackground.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Foundation
import SwiftUI

struct GlobalBackground: ViewModifier {

    func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.background)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func globalBackground() -> some View {
        modifier(GlobalBackground())
    }
}
