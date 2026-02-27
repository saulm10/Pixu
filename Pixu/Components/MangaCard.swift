//
//  MangaCard.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import CommonsLib
import SwiftUI

struct MangaCard: View {
    let manga: Manga
    let namespace: Namespace.ID
    let onTap: () -> Void
    
    @AppStorage(UserDefaultsK.showAdultContent.rawValue) private var showAdultContent: Bool = false

    init(
        manga: Manga,
        namespace: Namespace.ID,
        onTap: @escaping () -> Void = {}
    ) {
        self.manga = manga
        self.namespace = namespace
        self.onTap = onTap
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Imagen principal
            ImageUrlCache(
                manga.mainPicture,
                blurred: !showAdultContent && manga.isAdultContent
            )
                .scaledToFill()
                .frame(width: 170, height: 250)
                .clipped()
            
            // Rating en la esquina superior
            VStack {
                HStack {
                    if let score = manga.score, score > 0 {
                        RatingView(rating: score)
                            .padding(8)
                    }
                    Spacer()
                }
                Spacer()
            }
            
            // Título en la parte inferior
            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                if let japaneseTitle = manga.titleJapanese {
                    Text(japaneseTitle)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
        }
        .frame(width: 170, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
        .matchedTransitionSource(id: manga.id, in: namespace)
        .onTapGesture {
            onTap()
        }
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
        ZStack(alignment: .bottom) {
            // Fondo animado
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.2),
                            Color.gray.opacity(0.3),
                        ],
                        startPoint: isAnimating ? .topLeading : .bottomTrailing,
                        endPoint: isAnimating ? .bottomTrailing : .topLeading
                    )
                )
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.2)
                ],
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Rating skeleton
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white.opacity(0.3))
                        .frame(width: 50, height: 24)
                        .padding(8)
                    Spacer()
                }
                Spacer()
            }
            
            // Título skeleton
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(0.4))
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(0.3))
                    .frame(width: 100, height: 10)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 170, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview("Normal") {
    @Previewable @Namespace var namespace
    HStack(spacing: 12) {
        MangaCard(manga: .test, namespace: namespace)
        MangaCard(manga: .testList[1], namespace: namespace)
        MangaCard(manga: .testList[2], namespace: namespace)
    }
    .padding()
    .background(Color.black)
}

#Preview("Loading") {
    HStack(spacing: 12) {
        MangaCard.loading
        MangaCard.loading
        MangaCard.loading
    }
    .padding()
    .background(Color.black)
}
