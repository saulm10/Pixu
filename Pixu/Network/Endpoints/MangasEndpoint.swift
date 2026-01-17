//
//  Mangas.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 16/1/26.
//

import Foundation
import NetworkAPI

protocol MangasEndpoint {
    func getBestMangas(page: Int, per: Int) async -> MangaPage
    func getAllMangas(page: Int, per: Int) async -> MangaPage
    func getMangasByGenre(genre: String, page: Int, per: Int) async -> MangaPage
    func getMangasByDemographic(demographic: String, page: Int, per: Int) async -> MangaPage
    func getMangasByTheme(theme: String, page: Int, per: Int) async -> MangaPage
    func getMangasByAuthor(authorId: UUID, page: Int, per: Int) async -> MangaPage
}

struct Mangas: MangasEndpoint {
    let apiClient = NetworkManager.shared.client

    func getBestMangas(page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "list/bestMangas",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return MangaPage(items: [], metadata: PageMetadata(page: 1, per: 10, total: 0))
        }
    }
    
    func getAllMangas(page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "list/mangas",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return MangaPage(items: [], metadata: PageMetadata(page: 1, per: 10, total: 0))
        }
    }
    
    func getMangasByGenre(genre: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "list/mangaByGenre/\(genre)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return MangaPage(items: [], metadata: PageMetadata(page: 1, per: 10, total: 0))
        }
    }
    
    func getMangasByDemographic(demographic: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "list/mangaByDemographic/\(demographic)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return MangaPage(items: [], metadata: PageMetadata(page: 1, per: 10, total: 0))
        }
    }
    
    func getMangasByTheme(theme: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "list/mangaByTheme/\(theme)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return MangaPage(items: [], metadata: PageMetadata(page: 1, per: 10, total: 0))
        }
    }
    
    func getMangasByAuthor(authorId: UUID, page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "list/mangaByAuthor/\(authorId)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
        } catch {
            return MangaPage(items: [], metadata: PageMetadata(page: 1, per: 10, total: 0))
        }
    }
}

struct MangasTest: MangasEndpoint {
    func getBestMangas(page: Int = 1, per: Int = 10) async -> MangaPage {
        return MangaPage(
            items: Manga.testList,
            metadata: PageMetadata(page: page, per: per, total: Manga.testList.count)
        )
    }
    
    func getAllMangas(page: Int = 1, per: Int = 10) async -> MangaPage {
        return MangaPage(
            items: Manga.testList,
            metadata: PageMetadata(page: page, per: per, total: Manga.testList.count)
        )
    }
    
    func getMangasByGenre(genre: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        let filtered = Manga.testList.filter { manga in
            manga.genres.contains { $0.genre == genre }
        }
        return MangaPage(
            items: filtered,
            metadata: PageMetadata(page: page, per: per, total: filtered.count)
        )
    }
    
    func getMangasByDemographic(demographic: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        let filtered = Manga.testList.filter { manga in
            manga.demographics.contains { $0.demographic == demographic }
        }
        return MangaPage(
            items: filtered,
            metadata: PageMetadata(page: page, per: per, total: filtered.count)
        )
    }
    
    func getMangasByTheme(theme: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        let filtered = Manga.testList.filter { manga in
            manga.themes.contains { $0.theme == theme }
        }
        return MangaPage(
            items: filtered,
            metadata: PageMetadata(page: page, per: per, total: filtered.count)
        )
    }
    
    func getMangasByAuthor(authorId: UUID, page: Int = 1, per: Int = 10) async -> MangaPage {
        let filtered = Manga.testList.filter { manga in
            manga.authors.contains { $0.id == authorId }
        }
        return MangaPage(
            items: filtered,
            metadata: PageMetadata(page: page, per: per, total: filtered.count)
        )
    }
}
