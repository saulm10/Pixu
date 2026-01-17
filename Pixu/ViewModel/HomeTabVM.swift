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
    
    var filteredMangas: [Manga] = Manga.testList
    var bestMangas: [Manga] = []
    var genres: [Genre] = []
    
    var selectedManga: Manga? = nil
    var selectedGenre: Genre? = nil

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }
    
    func loadData() async {
        guard !hasLoaded else { return }

        async let genres = await apiManager.genre.getAllGenres()
        async let bestMangas = await apiManager.manga.getBestMangas(
            page: 1,
            per: 10
        ).items

        //await (genres, bestMangas)

        hasLoaded = true
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
