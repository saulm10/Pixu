//
//  Chip.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 16/1/26.
//

import SwiftUI

public struct Chip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    public var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.textOnTertiary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .fill(.brandTertiary)
            }
            .disabled(isSelected)
    }
}
