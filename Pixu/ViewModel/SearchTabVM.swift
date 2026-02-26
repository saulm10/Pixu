//
//  SearchTabVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI
import Shared

enum ViewState {
    case loading
    case loaded
    case empty
}

@MainActor @Observable
final class SearchTabVM {
    private let apiManager: APIManager

    var state: ViewState = .empty

    var searchText: String = "" {
        didSet {
            searchTask?.cancel()

            guard self.searchText.count >= 3 else {
                if selectedGenre.isEmpty && selectedTheme.isEmpty
                    && selectedDemographic.isEmpty
                {
                    filteredMangas = []
                    state = .empty
                }
                return
            }

            searchTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000)

                guard !Task.isCancelled else {
                    print("⏭️ Búsqueda cancelada (usuario sigue escribiendo)")
                    return
                }

                await resetAndReloadFilteredMangas()
            }
        }
    }

    private var searchTask: Task<Void, Never>?
    private var loadTask: Task<Void, Never>?

    var selectedDemographic: [String] = [] {
        didSet {
            guard selectedDemographic != oldValue else { return }
            Task {
                await resetAndReloadFilteredMangas()
            }
        }
    }
    var demographics: [String] = []

    var selectedTheme: [String] = [] {
        didSet {
            guard selectedTheme != oldValue else { return }
            Task {
                await resetAndReloadFilteredMangas()
            }
        }
    }
    var themes: [String] = []

    var selectedGenre: [String] = [] {
        didSet {
            guard selectedGenre != oldValue else { return }
            Task {
                await resetAndReloadFilteredMangas()
            }
        }
    }
    var genres: [String] = []

    var selectedManga: Manga?
    var filteredMangas: [Manga] = []
    private let filteredMangasPS = PageState()

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }

    func loadData() async {
        guard state != .loaded else { return }

        demographics = await apiManager.demographic.getAllDemographics()
        themes = await apiManager.theme.getAllThemes()
        genres = await apiManager.genre.getAllGenres()

        state = .empty
    }

    func loadFilteredMangas() async {
        loadTask?.cancel()

        loadTask = Task {
            if filteredMangas.isEmpty {
                state = .loading
            }

            guard let page = await filteredMangasPS.nextPage() else {
                return
            }

            let response = await apiManager.search.advancedSearchMangas(
                input: CustomSearchInputDTO(
                    searchContains: true,
                    searchTitle: searchText.isEmpty ? nil : searchText,
                    searchAuthorFirstName: nil,
                    searchAuthorLastName: nil,
                    searchGenres: selectedGenre.isEmpty ? nil : selectedGenre,
                    searchThemes: selectedTheme.isEmpty ? nil : selectedTheme,
                    searchDemographics: selectedDemographic.isEmpty
                        ? nil : selectedDemographic
                ),
                page: page,
                per: 20
            )

            guard !Task.isCancelled else {
                return
            }

            filteredMangas.append(contentsOf: response)

            if filteredMangas.isEmpty {
                state = .empty
            } else {
                state = .loaded
            }

            let hasMore = response.count == 20
            await filteredMangasPS.finishLoading(hasMore: hasMore)
        }

        await loadTask?.value
    }

    func resetAndReloadFilteredMangas() async {
        filteredMangas = []
        await filteredMangasPS.reset()

        let hasSearchCriteria =
            searchText.count >= 3 || !selectedGenre.isEmpty
            || !selectedTheme.isEmpty || !selectedDemographic.isEmpty

        if hasSearchCriteria {
            await loadFilteredMangas()
        } else {
            state = .empty
        }
    }

    func clearAllFilters() async {
        searchTask?.cancel()

        searchText = ""
        selectedDemographic = []
        selectedTheme = []
        selectedGenre = []
        filteredMangas = []

        await filteredMangasPS.reset()
        state = .empty
    }
}
