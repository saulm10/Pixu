//
//  MangaHCard.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 16/2/26.
//

import Components
import SwiftUI

struct MangaHCard: View {
    let manga: Manga
    let namespace: Namespace.ID
    let onTap: () -> Void

    @AppStorage(UserDefaultsK.showAdultContent.rawValue) private
        var showAdultContent: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

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
        ZStack(alignment: .bottomLeading) {
            // Imagen de fondo con gradient overlay
            ImageUrlCache(
                manga.mainPicture,
                blurred: !showAdultContent && manga.isAdultContent
            )
            .scaledToFill()
            .frame(height: 250)
            .clipped()
            .overlay {
                LinearGradient(
                    colors: [
                        .clear,
                        .clear,
                        .black.opacity(0.7),
                        .black.opacity(0.9),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .matchedTransitionSource(id: manga.id, in: namespace)

            // Rating en la esquina superior derecha
            VStack {
                HStack {
                    Spacer()
                    if let score = manga.score {
                        RatingView(rating: score)
                            .padding(12)
                    }
                }
                Spacer()
            }

            // Contenido sobre el gradient
            VStack(alignment: .leading, spacing: 6) {
                // Título en japonés
                if let japaneseTitle = manga.titleJapanese {
                    Text(japaneseTitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                }

                // Título principal
                Text(manga.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                // Géneros
                if !manga.genres.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(manga.genres.prefix(3), id: \.id) { genre in
                            Text(genre.genre)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background {
                                    Capsule()
                                        .fill(.white.opacity(0.15))
                                        .background {
                                            Capsule()
                                                .fill(.ultraThinMaterial)
                                        }
                                }
                        }
                    }
                }

                // Información adicional
                HStack(spacing: 12) {
                    if let chapters = manga.chapters, chapters > 0 {
                        Label("\(chapters)", systemImage: "book.fill")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    if let volumes = manga.volumes, volumes > 0 {
                        Label("\(volumes)", systemImage: "books.vertical.fill")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .padding(16)
        }
        .frame(
            minWidth: 325,
            maxWidth: isCompact ? 325 : 500,
            minHeight: 250,
            maxHeight: 250
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .glassEffect(in: RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Loading State

extension MangaHCard {
    static var loading: some View {
        MangaHCardSkeleton()
    }
}

private struct MangaHCardSkeleton: View {
    @State private var isAnimating = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Fondo animado
            RoundedRectangle(cornerRadius: 20)
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
                .overlay {
                    LinearGradient(
                        colors: [
                            .clear,
                            .clear,
                            .black.opacity(0.3),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }

            // Contenido skeleton
            VStack(alignment: .leading, spacing: 8) {
                // Título japonés
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(0.3))
                    .frame(width: 120, height: 12)

                // Título principal
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white.opacity(0.4))
                        .frame(maxWidth: 250, maxHeight: 20)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white.opacity(0.4))
                        .frame(maxWidth: 180, maxHeight: 20)
                }

                // Géneros
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.2))
                            .frame(width: 60, height: 22)
                    }
                }

                // Info adicional
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.3))
                        .frame(width: 50, height: 12)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.3))
                        .frame(width: 50, height: 12)
                }
            }
            .padding(16)
        }
        .frame(maxWidth: isCompact ? .infinity : 500, minHeight: 200)
        .glassEffect(in: RoundedRectangle(cornerRadius: 20))
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

// MARK: - Previews

#Preview("Normal") {
    @Previewable @Namespace var namespace
    ScrollView {
        VStack(spacing: 16) {
            MangaHCard(manga: .test, namespace: namespace)
            MangaHCard(manga: .testList[1], namespace: namespace)
            MangaHCard(manga: .testList[2], namespace: namespace)
        }
        .padding()
    }
    .background(Color.black)
}

#Preview("Loading") {
    ScrollView {
        VStack(spacing: 16) {
            MangaHCard.loading
            MangaHCard.loading
            MangaHCard.loading
        }
        .padding()
    }
    .background(Color.black)
}

#Preview("Tablet") {
    @Previewable @Namespace var namespace
    ScrollView {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 300, maximum: 500))
            ],
            spacing: 16
        ) {
            ForEach(Manga.testList, id: \.id) { manga in
                MangaHCard(manga: manga, namespace: namespace)
            }
        }
        .padding()
    }
    .background(Color.black)
    .environment(\.horizontalSizeClass, .regular)
}
