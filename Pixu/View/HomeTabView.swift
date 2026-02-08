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
    @Bindable var vm: HomeTabVM

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
                    HStack(spacing: 8) {
                        Image(.logoSimple)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)

                        Text("Pixie")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .bold()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        mainTabVM.selection = 2
                    }) {
                        CircleAvatar()
                    }
                    .buttonStyle(.plain)
                }
            }
            .task(priority: .userInitiated) {
                await vm.loadData()
            }
            .globalBackground()
        }.refreshable {
            Task {
                await vm.loadData(refresh: true)
            }
        }
    }

    private var content: some View {
        LazyVStack(alignment: .leading, spacing: 24) {

            // Sección: Mejores mangas
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Mejores mangas:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(
                            Array(vm.bestMangas.enumerated()),
                            id: \.element.id
                        ) { index, manga in
                            ZStack(alignment: .bottomTrailing) {
                                MangaCard(manga: manga) {
                                    vm.selectedManga = manga
                                }
                                .onAppear {
                                    if manga.id == vm.bestMangas.last?.id {
                                        Task {
                                            await vm.loadBestMangas()
                                        }
                                    }
                                }

                                Circle()
                                    .fill(.brandPrimary)
                                    .overlay {
                                        Text((index + 1).description)
                                            .font(.title)
                                            .foregroundColor(.textOnPrimary)
                                            .bold()
                                    }.frame(width: 50)
                            }
                        }
                    }
                }
            }

            // Sección: Colección propia
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Colección:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(
                            collections
                        ) { collection in
                            MangaCard(manga: collection.manga) {
                                vm.selectedManga = collection.manga
                            }
                            .onAppear {
                                if collection.manga.id == vm.bestMangas.last?.id
                                {
                                    Task {
                                        await vm.loadBestMangas()
                                    }
                                }
                            }
                        }
                    }
                }
            }.requiresAuthentication()

            // Sección: Mangas por género
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Mangas por género:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Chips de géneros
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(vm.genres, id: \.self) { genre in
                            Chip(
                                title: genre,
                                isSelected: vm.selectedGenre == genre
                            ) {
                                vm.selectedGenre = genre
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Grid de mangas filtrados
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 170))
                    ],
                ) {
                    ForEach(vm.filteredMangas) { manga in
                        MangaCard(manga: manga) {
                            vm.selectedManga = manga
                        }
                        .onAppear {
                            if manga.id == vm.filteredMangas.last?.id {
                                Task {
                                    await vm.loadFilteredMangas()
                                }
                            }
                        }

                    }
                }
            }
        }.padding(.horizontal)
    }
}

#Preview("Loged in", traits: .devEnvironment) {
    HomeTabView(vm: HomeTabVM(apiManager: .test))
}

#Preview("No Logged", traits: .devEnvironmentNoLogin) {
    HomeTabView(vm: HomeTabVM(apiManager: .test))
}
