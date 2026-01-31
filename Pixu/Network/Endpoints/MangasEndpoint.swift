//
//  Mangas.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 16/1/26.
//

import Foundation
import NetworkAPI

protocol MangasEndpoint {
    func getBestMangas(page: Int, per: Int) async -> [Manga]
    func getAllMangas(page: Int, per: Int) async -> [Manga]
    func getMangasByGenre(genre: String, page: Int, per: Int) async
        -> [Manga]
    func getMangasByDemographic(demographic: String, page: Int, per: Int) async
        -> [Manga]
    func getMangasByTheme(theme: String, page: Int, per: Int) async
        -> [Manga]
    func getMangasByAuthor(authorId: UUID, page: Int, per: Int) async
        -> [Manga]
}

struct Mangas: MangasEndpoint {
    let apiClient = NetworkManager.shared.client

    func getBestMangas(page: Int = 1, per: Int = 10) async -> [Manga] {
        do {
            let dto: PageDTO<MangaDTO> = try await apiClient.get(
                path: "list/bestMangas",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.items.map(\.toManga)
        } catch {
            return []
        }
    }

    func getAllMangas(page: Int = 1, per: Int = 10) async -> [Manga] {
        do {
            let dto: PageDTO<MangaDTO> = try await apiClient.get(
                path: "list/mangas",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.items.map(\.toManga)
        } catch {
            return []
        }
    }

    func getMangasByGenre(genre: String, page: Int = 1, per: Int = 10) async
        -> [Manga]
    {
        do {
            let dto: PageDTO<MangaDTO> = try await apiClient.get(
                path: "list/mangaByGenre/\(genre)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.items.map(\.toManga)
        } catch {
            return []
        }
    }

    func getMangasByDemographic(
        demographic: String,
        page: Int = 1,
        per: Int = 10
    ) async -> [Manga] {
        do {
            let dto: PageDTO<MangaDTO> = try await apiClient.get(
                path: "list/mangaByDemographic/\(demographic)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.items.map(\.toManga)
        } catch {
            return []
        }
    }

    func getMangasByTheme(theme: String, page: Int = 1, per: Int = 10) async
        -> [Manga]
    {
        do {
            let dto: PageDTO<MangaDTO> = try await apiClient.get(
                path: "list/mangaByTheme/\(theme)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.items.map(\.toManga)
        } catch {
            return []
        }
    }

    func getMangasByAuthor(authorId: UUID, page: Int = 1, per: Int = 10) async
        -> [Manga]
    {
        do {
            let dto: PageDTO<MangaDTO> = try await apiClient.get(
                path: "list/mangaByAuthor/\(authorId)",
                queryParameters: [
                    "page": page.description,
                    "per": per.description,
                ],
                temporaryAuth: nil
            )
            return dto.items.map(\.toManga)
        } catch {
            return []
        }
    }
}

struct MangasTest: MangasEndpoint {
    func getBestMangas(page: Int = 1, per: Int = 10) async -> [Manga] {
        return Manga.testList
    }

    func getAllMangas(page: Int = 1, per: Int = 10) async -> [Manga] {
        return Manga.testList
    }

    func getMangasByGenre(genre: String, page: Int = 1, per: Int = 10) async
        -> [Manga]
    {
        let filtered = Manga.testList.filter { manga in
            manga.genres.contains { $0.genre == genre }
        }
        return filtered
    }

    func getMangasByDemographic(
        demographic: String,
        page: Int = 1,
        per: Int = 10
    ) async -> [Manga] {
        let filtered = Manga.testList.filter { manga in
            manga.demographics.contains { $0.demographic == demographic }
        }
        return filtered
    }

    func getMangasByTheme(theme: String, page: Int = 1, per: Int = 10) async
        -> [Manga]
    {
        let filtered = Manga.testList.filter { manga in
            manga.themes.contains { $0.theme == theme }
        }
        return filtered
    }

    func getMangasByAuthor(authorId: UUID, page: Int = 1, per: Int = 10) async
        -> [Manga]
    {
        let filtered = Manga.testList.filter { manga in
            manga.authors.contains { $0.id == authorId }
        }
        return filtered
    }
}
