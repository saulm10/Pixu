//
//  UserView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import SwiftUI

struct UserView: View {
    @Bindable var vm: UserVM
    @State private var showingAddManga = false
    @State private var selectedCollectionForEdit: Collection?

    var body: some View {
        NavigationStack {
            ZStack {
                if vm.isLoading {
                    ProgressView("Cargando colección...")
                } else if vm.collections.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            statisticsSection
                            collectionsListSection
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mi Colección")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    userInitialButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddManga = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddManga) {
                AddMangaView { request in
                    //vm.addOrUpdateManga(request)
                }
            }
            .sheet(item: $selectedCollectionForEdit) { collection in
                EditMangaView(vm: EditColectionVM(collection: collection))
            }
            .onAppear {
                vm.loadCollections()
            }
        }
    }

    // MARK: - User Initial Button
    private var userInitialButton: some View {
        Button {
            // TODO: Navegar a configuración de usuario
        } label: {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .overlay(
                    Text("U")  // TODO: Obtener inicial del usuario
                        .font(.headline)
                        .foregroundColor(.white)
                )
        }
    }

    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(spacing: 12) {
            Text("Estadísticas")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                StatCard(
                    title: "Total Mangas",
                    value: "\(vm.collections.count)",
                    icon: "books.vertical.fill",
                    color: .blue
                )

                StatCard(
                    title: "Completas",
                    value: "\(vm.completeCollectionsCount)",
                    icon: "checkmark.seal.fill",
                    color: .green
                )
            }

            HStack(spacing: 12) {
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

    // MARK: - Collections List Section
    private var collectionsListSection: some View {
        VStack(spacing: 12) {
            Text("Mis Mangas")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                ForEach(vm.collections) { collection in
                    CollectionRowView(
                        collection: collection,
                        onEdit: { selectedCollectionForEdit = collection  },
                        onDelete: { vm.deleteCollection(collection.manga.id) }
                    )
                }
            }
        }
    }

    // MARK: - Empty State
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
                showingAddManga = true
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
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MangaRowView: View {
    let manga: Collection
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    private var progressPercentage: Double {
        guard let total = manga.manga.volumes, total > 0 else {
            return 0
        }
        return Double(manga.volumesOwned.count) / Double(total)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Portada (placeholder por ahora)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 70)
                .overlay(
                    Image(systemName: "book.fill")
                        .foregroundColor(.gray)
                )

            // Información
            VStack(alignment: .leading, spacing: 6) {
                Text(manga.manga.title)
                    .font(.headline)
                    .lineLimit(1)

                // Progreso de volúmenes
                HStack(spacing: 8) {
                    Text(
                        "\(manga.volumesOwned.count)/\(manga.manga.volumes ?? 0) tomos"
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    if manga.completeCollection {
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
                                manga.completeCollection
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
                if let reading = manga.readingVolume {
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

            Spacer()

            // Acciones
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                Button(action: { showDeleteConfirmation = true }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .confirmationDialog(
            "¿Eliminar este manga de tu colección?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Eliminar", role: .destructive, action: onDelete)
            Button("Cancelar", role: .cancel) {}
        }
    }
}
struct CollectionRowView: View {
    let collection: Collection
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    private var progressPercentage: Double {
        guard let total = collection.manga.volumes, total > 0 else { return 0 }
        return Double(collection.volumesOwned.count) / Double(total)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Portada
            AsyncImage(
                url: URL(string: collection.manga.mainPicture)
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "book.fill")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 50, height: 70)
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

            Spacer()

            // Acciones
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                Button(action: { showDeleteConfirmation = true }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .confirmationDialog(
            "¿Eliminar este manga de tu colección?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Eliminar", role: .destructive, action: onDelete)
            Button("Cancelar", role: .cancel) {}
        }
    }
}

#Preview {
    UserView(vm: UserVM(apiManager: .test))
}
