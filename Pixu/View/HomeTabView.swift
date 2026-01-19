//
//  HomeView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct HomeTabView: View {
    @Bindable var vm: HomeTabVM

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
                        Image(.logoSimple)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)

                        Text("Pixie")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .bold()

                        Spacer()
                    }
                }
            }
            .toolbarRole(.editor)
            .task {
                await vm.loadData()
            }
            .globalBackground()
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Sección: Mejores mangas
            VStack(alignment: .leading, spacing: 12) {
                Text("Mejores mangas:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(
                            Array(vm.bestMangas.enumerated()),
                            id: \.element.id
                        ) { index, manga in
                            ZStack(alignment: .bottomTrailing) {
                                MangaCard(manga: manga) {
                                    vm.selectedManga = manga
                                }
                                .frame(width: 150, height: 220)
                                Circle()
                                    .fill(.brandPrimary)
                                    .overlay {
                                        Text((index + 1).description)
                                            .font(.title)
                                            .foregroundColor(.textOnPrimary)
                                            .bold()
                                    }
                                    .frame(width: 50)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Sección: Mangas por género
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Mangas por género:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Chips de géneros
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
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
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16),
                    ],
                    spacing: 16
                ) {
                    ForEach(vm.filteredMangas) { manga in
                        MangaCard(manga: manga) {
                            vm.selectedManga = manga
                        }
                        .frame(height: 220)
                    }
                }
                .padding(.horizontal)
                ProgressView()
                    .onAppear {
                        Task.detached {
                            await vm.loadMoreFilteredMangas()
                        }
                    }
            }
        }

    }
}

#Preview {
    HomeTabView(vm: HomeTabVM(apiManager: .test))
}
