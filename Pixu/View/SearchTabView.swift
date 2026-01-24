//
//  SearchTabView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct SearchTabView: View {
    @Bindable var vm: SearchTabVM

    @State private var showDemographics: Bool = false
    @State private var showGenres: Bool = false
    @State private var showThemes: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .navigationDestination(item: $vm.selectedManga) { manga in
                MangaDetail(manga: manga)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Text("Buscar")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .bold()

                        Spacer()
                    }
                }
            }
            .toolbarRole(.editor)
            .task(priority: .userInitiated) {
                await vm.loadData()
            }
            .globalBackground()
            .sheet(isPresented: $showDemographics) {
                SearchablePickerView(
                    title: "Seleccionar Público",
                    items: vm.demographics,
                    selectedItems: $vm.selectedDemographic,
                    itemLabel: { $0 }
                )
            }
            .sheet(isPresented: $showGenres) {
                SearchablePickerView(
                    title: "Seleccionar Géneros",
                    items: vm.genres,
                    selectedItems: $vm.selectedGenre,
                    itemLabel: { $0 }
                )
            }
            .sheet(isPresented: $showThemes) {
                SearchablePickerView(
                    title: "Seleccionar Temas",
                    items: vm.themes,
                    selectedItems: $vm.selectedTheme,
                    itemLabel: { $0 }
                )
            }
        }
        .searchable(text: $vm.searchText, prompt: "Buscar mangas...")
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: 24) {
            // Chips de filtros
            filterChips
                .padding(.horizontal)

            // Contenido principal
            contentBody
        }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Chip de resetear solo visible si hay filtros activos
                if hasActiveFilters {
                    Chip(
                        title: "Limpiar",
                        isSelected: false,
                        onTap: {
                            Task {
                                await vm.clearAllFilters()
                            }
                        }
                    )
                }

                Chip(
                    title: vm.selectedDemographic.isEmpty
                        ? "Público"
                        : "Público (\(vm.selectedDemographic.count))",
                    isSelected: !vm.selectedDemographic.isEmpty,
                    onTap: { showDemographics = true }
                )

                Chip(
                    title: vm.selectedGenre.isEmpty
                        ? "Género" : "Género (\(vm.selectedGenre.count))",
                    isSelected: !vm.selectedGenre.isEmpty,
                    onTap: { showGenres = true }
                )

                Chip(
                    title: vm.selectedTheme.isEmpty
                        ? "Tema" : "Tema (\(vm.selectedTheme.count))",
                    isSelected: !vm.selectedTheme.isEmpty,
                    onTap: { showThemes = true }
                )
            }
        }
    }

    @ViewBuilder
    private var contentBody: some View {
        switch vm.state {
        case .loading:
            LoadingMangasList
        case .loaded:
            MangasList
        case .empty:
            ListEmptyView
        }
    }

    private var MangasList: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 150), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(vm.filteredMangas) { manga in
                MangaCard(manga: manga) {
                    vm.selectedManga = manga
                }
                .frame(height: 250)
                .task {
                    // Cargar más cuando llegamos al penúltimo elemento
                    if let lastManga = vm.filteredMangas.dropLast(1).last,
                        manga.id == lastManga.id
                    {
                        await vm.loadFilteredMangas()
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var LoadingMangasList: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ],
            spacing: 16
        ) {
            ForEach(0..<10, id: \.self) { _ in
                MangaCard.loading
                    .frame(height: 250)
            }
        }
        .padding(.horizontal)
    }

    private var ListEmptyView: some View {
        VStack(spacing: 16) {
            if hasActiveFilters {
                ContentUnavailableView(
                    "No se encontraron resultados",
                    systemImage: "magnifyingglass",
                    description: Text(
                        "Intenta con otros términos de búsqueda o filtros"
                    )
                )
            } else {
                ContentUnavailableView(
                    "Busca tu manga favorito",
                    systemImage: "book.fill",
                    description: Text(
                        "Usa la barra de búsqueda o los filtros para encontrar mangas"
                    )
                )
            }
        }
        .padding()
    }

    private var hasActiveFilters: Bool {
        !vm.searchText.isEmpty || !vm.selectedDemographic.isEmpty
            || !vm.selectedGenre.isEmpty || !vm.selectedTheme.isEmpty
    }
}

#Preview(traits: .devEnvironment) {
    SearchTabView(vm: SearchTabVM(apiManager: .test))
}

#Preview(traits: .devEnvironment) {
    let vm: SearchTabVM = SearchTabVM(apiManager: .test)
    vm.filteredMangas = Manga.testList
    vm.state = .loaded
    return SearchTabView(vm: vm)
}
