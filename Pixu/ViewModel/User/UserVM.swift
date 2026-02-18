//
//  UserVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Combine
import SwiftUI

@MainActor @Observable
final class UserVM {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager = .shared

    var state: ViewState = .empty

    var searchText: String = ""
    var totalMangas: Int = 0
    var completeCollectionsCount: Int = 0
    var totalVolumesOwned: Int = 0
    var currentlyReadingCount: Int = 0
    var mangasLowScoreCount: Int = 0
    var mangasMidScoreCount: Int = 0
    var mangasHighScoreCount: Int = 0
    var top5Average: Int = 0
    var failingMangasCount: Int = 0
    var uncommonMangasCount: Int = 0
    var bestManga: Manga?
    var worstManga: Manga?

    var selectedManga: Manga?
    var userCollection: [UserCollection] = []

    var isLoading: Bool = false
    
    var completCollections: Bool = false
    var readingCollection: Bool = false

    var filteredCollection: [UserCollection] {
        var result = userCollection
        
        if !searchText.isEmpty {
            result = result.filter { collection in
                collection.manga.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if completCollections {
            result = result.filter { $0.completeCollection }
        }
        
        if readingCollection {
            result = result.filter { $0.readingVolume != nil }
        }
        
        return result
    }

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }

    func loadUserCollection() {
        let collection = databaseManager.getAllCollection()
        self.userCollection = collection

        self.totalMangas = collection.count
        
        self.completeCollectionsCount = collection.count(where: {
            $0.completeCollection
        })

        self.totalVolumesOwned =
            collection
            .reduce(0) { $0 + ($1.volumesOwned.count) }

        self.currentlyReadingCount = collection.count(where: {
            $0.readingVolume != nil
        })

        self.mangasLowScoreCount = collection.count(where: {
            ($0.manga.score ?? 0) < 5
        })

        self.mangasMidScoreCount = collection.count(where: {
            let score = $0.manga.score ?? 0
            return score >= 5 && score < 8
        })

        self.mangasHighScoreCount = collection.count(where: {
            ($0.manga.score ?? 0) >= 8
        })

        let top5Scores = collection
            .compactMap { $0.manga.score }
            .sorted(by: >)
            .prefix(5)

        self.top5Average = top5Scores.isEmpty ? 0 : Int(top5Scores.reduce(0.0, +) / Double(top5Scores.count))
        
        // Mangas con puntuación menor a 5 (suspenso)
        self.failingMangasCount = collection.count(where: {
            ($0.manga.score ?? 0) < 5
        })

        self.uncommonMangasCount = collection.count(where: {
            ($0.manga.score ?? 0) == 0
        })

        // Mejor y peor manga por score
        let scoredCollection = collection.filter { $0.manga.score != nil }

        self.bestManga = scoredCollection
            .max(by: { ($0.manga.score ?? 0) < ($1.manga.score ?? 0) })?.manga

        self.worstManga = scoredCollection
            .min(by: { ($0.manga.score ?? 0) < ($1.manga.score ?? 0) })?.manga
    }
}
