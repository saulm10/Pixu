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
    var hasLoaded = false
    
    // Arrays simples
    var filteredMangas: [Manga] = []
    var bestMangas: [Manga] = []
    
    // PageStates simples
    private let filteredMangasPS = PageState()
    private let bestMangasPS = PageState()
    
    var genres: [String] = []
    var selectedManga: Manga?
    
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
        
        await loadBestMangas()
        await loadFilteredMangas()
        
        hasLoaded = true
    }
    
    func loadBestMangas() async {
        guard let page = await bestMangasPS.nextPage() else { return }
        
        let response = await apiManager.manga.getBestMangas(page: page, per: 20)
        bestMangas.append(contentsOf: response)
        
        let hasMore = response.count == 20
        await bestMangasPS.finishLoading(hasMore: hasMore)
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
    
    private func resetAndReloadFilteredMangas() async {
        filteredMangas = []
        await filteredMangasPS.reset()
        await loadFilteredMangas()
    }
}
