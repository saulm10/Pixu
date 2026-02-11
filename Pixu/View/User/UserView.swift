//
//  UserView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Components
import SwiftData
import SwiftUI

struct UserView: View {
    @Environment(MainTabVM.self) private var mainTabVM

    @Bindable var vm: UserVM
    @State var userVM: UserAccountVM = UserAccountVM()

    @Query(sort: \UserCollection.manga.title) private var collections:
        [UserCollection]

    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .navigationDestination(item: $vm.selectedManga) { manga in
                MangaDetail(vm: MangaDetailVM(manga: manga))
            }
            .toolbarRole(.editor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mi colección")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        UserAcountView(vm: userVM)
                    } label: {
                        CircleAvatar()
                    }
                }
            }
            .globalBackground()
        }
    }

    private var content: some View {
        ZStack {
            if vm.isLoading {
                ProgressView("Cargando colección...")
            } else if collections.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 20) {
                    statisticsSection
                    collectionsListSection
                }
                .padding()
            }
        }
    }

    private var statisticsSection: some View {
        LazyVStack(spacing: 12) {
            Text("Estadísticas")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                StatCard(
                    title: "Total Mangas",
                    value: "\(collections.count)",
                    icon: "books.vertical.fill",
                    color: .blue
                )

                StatCard(
                    title: "Completas",
                    value: "\(vm.completeCollectionsCount)",
                    icon: "checkmark.seal.fill",
                    color: .green
                )
                StatCard(
                    title: "Total Tomos",
                    value: "\(vm.totalVolumesOwned)",
                    icon: "book.fill",
                    color: .orange
                )

                StatCard(
                    title: "En Lectura",
                    value: "\(vm.currentlyReadingCount)",
                    icon: "book.pages.fill",
                    color: .purple
                )
            }
        }
    }

    private var collectionsListSection: some View {
        LazyVStack(spacing: 12) {
            Text("Mis Mangas")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                ForEach(collections) { collection in
                    CollectionRowView(
                        collection: collection,
                        onTap: { vm.selectedManga = collection.manga }
                    )
                }

            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No tienes mangas en tu colección")
                .font(.title3)
                .fontWeight(.medium)

            Text("Añade tu primer manga para empezar")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button {
                mainTabVM.selection = 3
            } label: {
                Label("Añadir mi primer manga", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(12)
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}

struct CollectionRowView: View {
    let collection: UserCollection
    let onTap: () -> Void

    @State private var showDeleteConfirmation = false

    private var progressPercentage: Double {
        guard let total = collection.manga.volumes, total > 0 else { return 0 }
        return Double(collection.volumesOwned.count) / Double(total)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Portada
            ImageUrlCache(collection.manga.mainPicture)
                .frame(width: 80, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Información
            VStack(alignment: .leading, spacing: 6) {
                Text(collection.manga.title)
                    .font(.headline)
                    .lineLimit(1)

                // Progreso de volúmenes
                HStack(spacing: 8) {
                    Text(
                        "\(collection.volumesOwned.count)/\(collection.manga.volumes ?? 0) tomos"
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    if collection.completeCollection {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Completa")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }

                // Barra de progreso
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                collection.completeCollection
                                    ? Color.green : Color.blue
                            )
                            .frame(
                                width: geometry.size.width * progressPercentage,
                                height: 6
                            )
                    }
                }
                .frame(height: 6)

                // Volumen de lectura
                if let reading = collection.readingVolume {
                    Text("Leyendo tomo \(reading)")
                        .font(.caption)
                        .foregroundColor(.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(6)
                } else {
                    Text("Sin lectura activa")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .cornerRadius(12)
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 14)
        )
    }
}

#Preview(traits: .devEnvironment) {
    UserView(vm: UserVM(apiManager: .test))
}
