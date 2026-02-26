//
//  SearchTabView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct SearchTabView: View {
    @Environment(MainTabVM.self) private var mainTabVM
    @Bindable var vm: SearchTabVM

    @State private var showDemographics: Bool = false
    @State private var showGenres: Bool = false
    @State private var showThemes: Bool = false

    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .navigationDestination(item: $vm.selectedManga) { manga in
                MangaDetail(
                    vm: MangaDetailVM(manga: manga),
                    namespace: namespace
                )
            }
            .toolbarRole(.editor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(.tabsearchTitle)
                        .font(.largeTitle)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        UserAcountView(vm: UserAccountVM())
                    } label: {
                        CircleAvatar()
                    }
                    .buttonStyle(.plain)
                }
            }
            .task(priority: .userInitiated) {
                await vm.loadData()
            }
            .sheet(isPresented: $showDemographics) {
                SearchablePickerView(
                    title: .tabsearchSheetSelectaudience,
                    items: vm.demographics,
                    selectedItems: $vm.selectedDemographic,
                    itemLabel: { $0 }
                )
            }
            .sheet(isPresented: $showGenres) {
                SearchablePickerView(
                    title: .tabsearchSheetSelectagenres,
                    items: vm.genres,
                    selectedItems: $vm.selectedGenre,
                    itemLabel: { $0 }
                )
            }
            .sheet(isPresented: $showThemes) {
                SearchablePickerView(
                    title: .tabsearchSheetSelecthemes,
                    items: vm.themes,
                    selectedItems: $vm.selectedTheme,
                    itemLabel: { $0 }
                )
            }
            .globalBackground()
        }
        .searchable(text: $vm.searchText, prompt: .tabsearchPrompt)
        .overlay {
            if vm.state == .empty {
                ContentUnavailableView(
                    .tabsearchNoresults,
                    systemImage: "magnifyingglass",
                    description: Text(
                        .tabsearchNoresultstext
                    )
                )
            }
        }
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: 24) {
            // Chips de filtros
            filterChips

            // Contenido principal
            MangasList
        }.padding(.horizontal)
    }

    private var filterChips: some View {
        HStack(spacing: 8) {
            if hasActiveFilters {
                Chip(
                    title: .tabsearchClean,
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
                    ? .tabsearchAudience
                    : .tabsearchAudiencenum(
                        variableName: vm.selectedDemographic.count
                    ),
                isSelected: !vm.selectedDemographic.isEmpty,
                onTap: { showDemographics = true }
            )

            Chip(
                title: vm.selectedGenre.isEmpty
                    ? .tabsearchGenre
                    : .tabsearchGenrenum(variableName: vm.selectedGenre.count),
                isSelected: !vm.selectedGenre.isEmpty,
                onTap: { showGenres = true }
            )

            Chip(
                title: vm.selectedTheme.isEmpty
                    ? .tabsearchTheme
                    : .tabsearchThemenum(variableName: vm.selectedTheme.count),
                isSelected: !vm.selectedTheme.isEmpty,
                onTap: { showThemes = true }
            )
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
                MangaCard(manga: manga, namespace: namespace) {
                    vm.selectedManga = manga
                }
                .frame(height: 250)
                .task {
                    if let lastManga = vm.filteredMangas.dropLast(1).last,
                        manga.id == lastManga.id
                    {
                        await vm.loadFilteredMangas()
                    }
                }
            }
        }
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
