//
//  HorizontalScroll.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 23/2/26.
//

import SwiftUI

func horizontalScroll<T: Identifiable, C: View, S: View>(
    _ items: [T],
    skeletonCount: Int = 4,
    @ViewBuilder skeleton: @escaping () -> S,
    @ViewBuilder content: @escaping (T) -> C
) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
            if items.isEmpty {
                ForEach(0..<skeletonCount, id: \.self) { i in
                    skeleton()
                        .id("skeleton_\(i)")
                }
            } else {
                ForEach(items) { item in
                    content(item)
                        .id(item.id)
                }
            }
        }
    }
    .contentMargins(.leading, 16, for: .scrollContent)
}
