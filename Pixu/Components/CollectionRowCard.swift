//
//  CollectionRowCard.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 16/2/26.
//

import CommonsLib
import SwiftUI

struct CollectionRowCard: View {
    let collection: UserCollection
    let onTap: () -> Void

    @State private var showDeleteConfirmation = false
    @AppStorage(UserDefaultsK.showAdultContent.rawValue) private
        var showAdultContent: Bool = false

    private var progressPercentage: Double {
        guard let total = collection.manga.volumes, total > 0 else { return 0 }
        return min(Double(collection.volumesOwned.count) / Double(total), 1.0)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Portada con gradient overlay
            ImageUrlCache(
                collection.manga.mainPicture,
                blurred: !showAdultContent && collection.manga.isAdultContent

            )
            .scaledToFill()
            .frame(width: 100, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Información
            VStack(alignment: .leading, spacing: 6) {
                // Título
                Text(collection.manga.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)

                // Título japonés si existe
                if let japaneseTitle = collection.manga.titleJapanese {
                    Text(japaneseTitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Progreso compacto
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(verbatim: 
                            "\(collection.volumesOwned.count)/\(collection.manga.volumes ?? 0)"
                        )
                        .font(.caption)
                        .fontWeight(.semibold)

                        Spacer()

                        Text(verbatim: "\(Int(progressPercentage * 100))%")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    // Barra de progreso
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)

                            Capsule()
                                .fill(
                                    collection.completeCollection
                                        ? Color.green
                                        : .primary
                                )
                                .frame(
                                    width: geometry.size.width
                                        * progressPercentage,
                                    height: 6
                                )
                                .animation(
                                    .spring(response: 0.6),
                                    value: progressPercentage
                                )
                        }
                    }
                    .frame(height: 6)
                }

                // Géneros
                if !collection.manga.genres.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(collection.manga.genres.prefix(3), id: \.id) {
                            genre in
                            Text(genre.genre)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background {
                                    Capsule()
                                        .fill(.primary.opacity(0.15))
                                        .background {
                                            Capsule()
                                                .fill(.ultraThinMaterial)
                                        }
                                }
                        }
                    }
                }

                // Badges compactos
                HStack(spacing: 6) {
                    if collection.completeCollection {
                        CompactBadge(icon: "checkmark.circle.fill")
                    }

                    if let reading = collection.readingVolume {
                        CompactBadge(icon: "book.fill")
                        Text(.globalVol(numVolumens: reading))
                            .font(.caption2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 140)
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.background.opacity(0.3))
        }
        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Supporting Views

private struct CompactBadge: View {
    let icon: String

    var body: some View {
        Image(systemName: icon)
            .font(.caption)
            .padding(4)
            .background {
                Circle()
                    .fill(.primary.opacity(0.15))
            }
    }
}

#Preview("Normal") {
    VStack(spacing: 16) {
        CollectionRowCard(
            collection: .test
        ) {}

        CollectionRowCard(
            collection: .test
        ) {}

        CollectionRowCard(
            collection: .test
        ) {}
    }
    .padding()
    .background(Color.black)
}
