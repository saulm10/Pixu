//
//  MangaRepository.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 3/2/26.
//

import Foundation
import SwiftData

extension DatabaseManager {
    func resolveManga(_ incomingManga: Manga) throws -> Manga {
        let mangaId = incomingManga.id
        let descriptor = FetchDescriptor<Manga>(predicate: #Predicate { $0.id == mangaId })
        
        if let existingManga = try modelContext.fetch(descriptor).first {
            existingManga.title = incomingManga.title
            existingManga.mainPicture = incomingManga.mainPicture
            existingManga.url = incomingManga.url
            existingManga.chapters = incomingManga.chapters
            existingManga.volumes = incomingManga.volumes
            existingManga.score = incomingManga.score
            existingManga.status = incomingManga.status
            
            existingManga.authors = try resolveAuthors(incomingManga.authors)
            existingManga.genres = try resolveGenres(incomingManga.genres)
            existingManga.themes = try resolveThemes(incomingManga.themes)
            existingManga.demographics = try resolveDemographics(incomingManga.demographics)
            
            return existingManga
        } else {
            modelContext.insert(incomingManga)
            
            incomingManga.authors = try resolveAuthors(incomingManga.authors)
            incomingManga.genres = try resolveGenres(incomingManga.genres)
            incomingManga.themes = try resolveThemes(incomingManga.themes)
            incomingManga.demographics = try resolveDemographics(incomingManga.demographics)
            
            return incomingManga
        }
    }
}
