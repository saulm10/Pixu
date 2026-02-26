//
//  HomeTabVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI
import Shared

@MainActor @Observable
final class HomeTabVM {
    private let apiManager: APIManager
    var hasLoaded = false

    // Arrays simples
    var bestMangas: [Manga] = []
    var mangasRandomTheme: [Manga] = []
    var mangasRandomDemographic: [Manga] = []
    var filteredMangas: [Manga] = []

    // PageStates simples
    private let bestMangasPS = PageState()
    private let mangasRandomThemePS = PageState()
    private let mangasRandomDemographicPS = PageState()
    private let filteredMangasPS = PageState()

    var genres: [String] = []
    var themes: [String] = []
    var demographics: [String] = []

    var selectedManga: Manga?
    var selectedTheme: String? = nil {
        didSet {
            guard selectedTheme != oldValue else { return }
            Task { await resetAndReloadMangasRandomTheme() }
        }
    }
    var selectedDemographic: String? = nil {
        didSet {
            guard selectedDemographic != oldValue else { return }
            Task { await resetAndReloadRandomDemographic() }
        }
    }
    var selectedGenre: String? = nil {
        didSet {
            guard selectedGenre != oldValue else { return }
            Task { await resetAndReloadFilteredMangas() }
        }
    }

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }

    func loadData(refresh: Bool = false) async {
        refresh ? hasLoaded = false : ()

        guard !hasLoaded else { return }

        genres = await apiManager.genre.getAllGenres()
        selectedGenre = genres.first

        themes = await apiManager.theme.getAllThemes()
        selectedTheme = themes.randomElement()

        demographics = await apiManager.demographic.getAllDemographics()
        selectedDemographic = demographics.randomElement()

        await loadBestMangas()

        hasLoaded = true
    }

    func loadBestMangas() async {
        guard let page = await bestMangasPS.nextPage() else { return }

        let response = await apiManager.manga.getBestMangas(page: page, per: 20)
        bestMangas.append(contentsOf: response)

        let hasMore = response.count == 20
        await bestMangasPS.finishLoading(hasMore: hasMore)
    }

    func loadRandomThemeMangas() async {
        guard let page = await mangasRandomThemePS.nextPage() else { return }
        guard let theme = selectedTheme else {
            await mangasRandomThemePS.finishLoading(hasMore: false)
            return
        }

        let response = await apiManager.manga.getMangasByTheme(
            theme: theme,
            page: page,
            per: 20
        )
        mangasRandomTheme.append(contentsOf: response)

        let hasMore = response.count == 20
        await mangasRandomThemePS.finishLoading(hasMore: hasMore)
    }

    func loadRandomDemographicsMangas() async {
        guard let page = await mangasRandomDemographicPS.nextPage() else {
            return
        }
        guard let demographic = selectedDemographic else {
            await mangasRandomDemographicPS.finishLoading(hasMore: false)
            return
        }

        let response = await apiManager.manga.getMangasByDemographic(
            demographic: demographic,
            page: page,
            per: 20
        )
        mangasRandomDemographic.append(contentsOf: response)

        let hasMore = response.count == 20
        await mangasRandomDemographicPS.finishLoading(hasMore: hasMore)
    }

    func loadFilteredMangas() async {
        guard let page = await filteredMangasPS.nextPage() else { return }
        guard let genre = selectedGenre else {
            await filteredMangasPS.finishLoading(hasMore: false)
            return
        }

        let response = await apiManager.manga.getMangasByGenre(
            genre: genre,
            page: page,
            per: 20
        )
        filteredMangas.append(contentsOf: response)

        let hasMore = response.count == 20
        await filteredMangasPS.finishLoading(hasMore: hasMore)
    }
    
    private func resetAndReloadMangasRandomTheme() async {
        mangasRandomTheme = []
        await mangasRandomThemePS.reset()
        await loadRandomThemeMangas()
    }

    private func resetAndReloadRandomDemographic() async {
        mangasRandomDemographic = []
        await mangasRandomThemePS.reset()
        await loadRandomDemographicsMangas()
    }

    private func resetAndReloadFilteredMangas() async {
        filteredMangas = []
        await filteredMangasPS.reset()
        await loadFilteredMangas()
    }
}
