//
//  MangaCard.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import Components
import SwiftUI

struct MangaCard: View {
    let manga: Manga
    let onTap: () -> Void

    init(
        manga: Manga,
        onTap: @escaping () -> Void = {}
    ) {
        self.manga = manga
        self.onTap = onTap
    }

    var body: some View {
        ImageUrlCache(manga.mainPicture)
            .frame(width: 170, height: 250)
            .clipped()
            .overlay(alignment: .topLeading) { 
                RatingView(rating: manga.score ?? 0)
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .onTapGesture {
                onTap()
            }
            .glassEffect(
                in: RoundedRectangle(cornerRadius: 14)
            )
    }
}

extension MangaCard {
    static var loading: some View {
        MangaCardSkeleton()
    }
}

private struct MangaCardSkeleton: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.2),
                            Color.gray.opacity(0.3),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0),
                                ],
                                startPoint: isAnimating ? .leading : .trailing,
                                endPoint: isAnimating ? .trailing : .leading
                            )
                        )
                        .opacity(0.6)
                )
        }
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 14)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview("Normal") {
    MangaCard(manga: .test)
        .frame(width: 300, height: 400)
}

#Preview("Loading") {
    MangaCard.loading
        .frame(width: 300, height: 400)
}
