//
//  Chip.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 16/1/26.
//

import SwiftUI

public struct Chip: View {
    let title: LocalizedStringResource
    let icon: String?
    let isSelected: Bool
    let onTap: () -> Void

    public init(
        title: LocalizedStringResource,
        icon: String? = nil,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.footnote)
            }

            Text(title)
                .font(.subheadline)
        }
        .foregroundStyle(isSelected ? .textOnPrimary : .textOnTertiary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background {
            Capsule()
                .fill(isSelected ? .brandPrimary : .brandTertiary)
        }
        .onTapGesture {
            onTap()
        }
        .glassEffect(
            in: Capsule()
        )
    }
}
