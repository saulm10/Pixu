//
//  HomeTabVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI

@MainActor @Observable
final class HomeTabVM {
    private let apiManager: APIManager

    private var hasLoaded = false

    var filteredMangas: [Manga] = []
    var bestMangas: Pager<Manga>
    var genres: [String] = []

    var selectedManga: Manga? = nil
    var selectedGenre: String? = nil

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager

        self.bestMangas = Pager(pageSize: 10) { page, per in
            await apiManager.manga.getBestMangas(
                page: page,
                per: per
            ).items
        }
    }

    func loadData() async {
        guard !hasLoaded else { return }

        genres = await apiManager.genre.getAllGenres()
        selectedGenre = genres.first

        await bestMangas.loadNextPage()

        if let genre = selectedGenre {
            await loadMangasByGenre(genre)
        }

        hasLoaded = true
    }

    func loadMangasByGenre(_ genre: String) async {
        filteredMangas = await apiManager.manga
            .getMangasByGenre(
                genre: genre,
                page: 1,
                per: 10
            ).items
    }

    //    func loadBestMangas() async {
    //        let page = await apiManager.manga.getBestMangas(page: 1, per: 10)
    //        bestMangas = page.items
    //    }
    //
    //    func loadGenres() async {
    //        genres =
    //    }

    func loadFiltededMangas() async {

    }

    func loadMoreFilteredMangas() async {

    }

}
