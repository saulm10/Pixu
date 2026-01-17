//
//  Search.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 17/1/26.
//

import Foundation
import NetworkAPI

protocol SearchEndpoint {
    func searchMangasBeginsWith(search: String) async -> [Manga]
    func searchMangasContains(search: String, page: Int, per: Int) async -> MangaPage
    func searchAuthors(search: String) async -> [Author]
    func getMangaById(id: String) async -> Manga?
    func advancedSearchMangas(input: CustomSearchInputDTO, page: Int, per: Int) async -> MangaPage
}

struct Searchs: SearchEndpoint {
    let apiClient = NetworkManager.shared.client

    func searchMangasBeginsWith(search: String) async -> [Manga] {
        do {
            return try await apiClient.get(
                path: "search/mangasBeginsWith/\(search)",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
    
    func searchMangasContains(search: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.get(
                path: "search/mangasContains/\(search)",
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
    
    func searchAuthors(search: String) async -> [Author] {
        do {
            return try await apiClient.get(
                path: "search/author/\(search)",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
    
    func getMangaById(id: String) async -> Manga? {
        do {
            return try await apiClient.get(
                path: "search/manga/\(id)",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return nil
        }
    }
    
    func advancedSearchMangas(input: CustomSearchInputDTO, page: Int = 1, per: Int = 10) async -> MangaPage {
        do {
            return try await apiClient.post(
                path: "search/manga",
                body: input,
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

struct SearchsTest: SearchEndpoint {
    func searchMangasBeginsWith(search: String) async -> [Manga] {
        return Manga.testList.filter { manga in
            manga.title.lowercased().hasPrefix(search.lowercased()) ||
            (manga.titleEnglish?.lowercased().hasPrefix(search.lowercased()) ?? false)
        }
    }
    
    func searchMangasContains(search: String, page: Int = 1, per: Int = 10) async -> MangaPage {
        let filtered = Manga.testList.filter { manga in
            manga.title.lowercased().contains(search.lowercased()) ||
            (manga.titleEnglish?.lowercased().contains(search.lowercased()) ?? false)
        }
        return MangaPage(
            items: filtered,
            metadata: PageMetadata(page: page, per: per, total: filtered.count)
        )
    }
    
    func searchAuthors(search: String) async -> [Author] {
        return Author.testList.filter { author in
            author.firstName.lowercased().contains(search.lowercased()) ||
            author.lastName.lowercased().contains(search.lowercased())
        }
    }
    
    func getMangaById(id: String) async -> Manga? {
        return Manga.testList.first { $0.id.description == id }
    }
    
    func advancedSearchMangas(input: CustomSearchInputDTO, page: Int = 1, per: Int = 10) async -> MangaPage {
        var filtered = Manga.testList
        
        if let title = input.searchTitle {
            filtered = filtered.filter { manga in
                if input.searchContains {
                    return manga.title.lowercased().contains(title.lowercased())
                } else {
                    return manga.title.lowercased().hasPrefix(title.lowercased())
                }
            }
        }
        
        if let firstName = input.searchAuthorFirstName {
            filtered = filtered.filter { manga in
                manga.authors.contains { $0.firstName.lowercased().contains(firstName.lowercased()) }
            }
        }
        
        if let lastName = input.searchAuthorLastName {
            filtered = filtered.filter { manga in
                manga.authors.contains { $0.lastName.lowercased().contains(lastName.lowercased()) }
            }
        }
        
        if let genres = input.searchGenres {
            filtered = filtered.filter { manga in
                genres.allSatisfy { genre in
                    manga.genres.contains { $0.genre == genre }
                }
            }
        }
        
        if let themes = input.searchThemes {
            filtered = filtered.filter { manga in
                themes.allSatisfy { theme in
                    manga.themes.contains { $0.theme == theme }
                }
            }
        }
        
        if let demographics = input.searchDemographics {
            filtered = filtered.filter { manga in
                demographics.allSatisfy { demographic in
                    manga.demographics.contains { $0.demographic == demographic }
                }
            }
        }
        
        return MangaPage(
            items: filtered,
            metadata: PageMetadata(page: page, per: per, total: filtered.count)
        )
    }
}
