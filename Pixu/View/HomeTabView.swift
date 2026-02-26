//
//  HomeView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftData
import SwiftUI

struct HomeTabView: View {
    @Environment(AuthStatus.self) private var authStatus
    @Environment(MainTabVM.self) private var mainTabVM
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    @Bindable var vm: HomeTabVM
    @Query(sort: \UserCollection.manga.title) private var collections:
        [UserCollection]
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
                    HStack(spacing: 8) {
                        Image(.logoSimple)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Text(verbatim: "Pixie")
                            .font(.largeTitle)
                            .bold()
                    }
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
            .globalBackground()
        }
        .refreshable {
            Task { await vm.loadData(refresh: true) }
        }
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: 24) {

            // Sección: Mejores mangas
            sectionHeader(.tabHomeBestmangas)
            horizontalScroll(vm.bestMangas, skeleton: { MangaCard.loading }) {
                manga in
                MangaHCard(manga: manga, namespace: namespace) {
                    vm.selectedManga = manga
                }
                .frame(width: isCompact ? nil : 450)
                .onAppear {
                    if manga.id == vm.bestMangas.last?.id {
                        Task { await vm.loadBestMangas() }
                    }
                }
            }

            // Sección: Random mangas by theme
            sectionHeader(
                LocalizedStringResource.tabHomeFindmangasby(
                    vm.selectedTheme ?? ""
                )
            )
            horizontalScroll(
                vm.mangasRandomTheme,
                skeleton: { MangaCard.loading }
            ) { manga in
                MangaCard(manga: manga, namespace: namespace) {
                    vm.selectedManga = manga
                }
                .onAppear {
                    if manga.id == vm.mangasRandomTheme.last?.id {
                        Task { await vm.loadRandomThemeMangas() }
                    }
                }
            }

            // Sección: Colección
            if !collections.isEmpty {
                sectionHeader(.tabHomeColection)
                horizontalScroll(collections, skeleton: { MangaCard.loading }) {
                    collection in
                    MangaCard(manga: collection.manga, namespace: namespace) {
                        vm.selectedManga = collection.manga
                    }
                    .onAppear {
                        if collection.manga.id == vm.bestMangas.last?.id {
                            Task { await vm.loadBestMangas() }
                        }
                    }
                }
                .requiresAuthentication()
            }

            // Sección: Random mangas by demographic
            sectionHeader(
                LocalizedStringResource
                    .tabHomeFindmangasby(vm.selectedDemographic ?? "")
            )
            horizontalScroll(
                vm.mangasRandomDemographic,
                skeleton: { MangaCard.loading }
            ) { manga in
                MangaCard(manga: manga, namespace: namespace) {
                    vm.selectedManga = manga
                }
                .onAppear {
                    if manga.id == vm.mangasRandomDemographic.last?.id {
                        Task { await vm.loadRandomDemographicsMangas() }
                    }
                }
            }

            // Sección: Mangas por género
            sectionHeader(.tabHomeMangasbygenre)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(vm.genres, id: \.self) { genre in
                        Chip(
                            title: LocalizedStringResource(
                                stringLiteral: genre
                            ),
                            isSelected: vm.selectedGenre == genre
                        ) {
                            vm.selectedGenre = genre
                        }
                    }
                }
            }.contentMargins(.leading, 16, for: .scrollContent)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))]) {
                if vm.filteredMangas.isEmpty {
                    ForEach(0..<6, id: \.self) { _ in
                        MangaCard.loading
                    }
                } else {
                    ForEach(vm.filteredMangas) { manga in
                        MangaCard(manga: manga, namespace: namespace) {
                            vm.selectedManga = manga
                        }
                        .onAppear {
                            if manga.id == vm.filteredMangas.last?.id {
                                Task { await vm.loadFilteredMangas() }
                            }
                        }
                    }
                }
            }.padding(.horizontal)
        }
    }

    private func sectionHeader(_ title: LocalizedStringResource) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
}

#Preview("Loged in", traits: .devEnvironment) {
    HomeTabView(vm: HomeTabVM(apiManager: .test))
}

#Preview("No Logged", traits: .devEnvironmentNoLogin) {
    HomeTabView(vm: HomeTabVM(apiManager: .test))
}
