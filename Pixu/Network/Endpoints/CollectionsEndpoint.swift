//
//  UserCollection.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation
import NetworkAPI

protocol CollectionEndpoint {
    func getCollection() async -> [UserCollection]
    func getMangaFromCollection(id: String) async -> UserCollection?
    func addMangaToCollection(input: UserMangaCollectionRequestInputDTO) async -> Bool
    func removeMangaFromCollection(id: String) async -> Bool
}

struct Collections: CollectionEndpoint {
    let apiClient = NetworkManager.shared.client
    
    func getCollection() async -> [UserCollection] {
        do {
            let dto: [CollectionDTO] = try await apiClient.get(
                path: "collection/manga",
                queryParameters: [:],
                temporaryAuth: nil
            )
            return dto.map(\.toCollection)
        } catch {
            return []
        }
    }
    
    func getMangaFromCollection(id: String) async -> UserCollection? {
        do {
            let dto: CollectionDTO = try await apiClient.get(
                path: "collection/manga/\(id)",
                queryParameters: [:],
                temporaryAuth: nil
            )
            return dto.toCollection
        } catch {
            return nil
        }
    }
    
    func addMangaToCollection(input: UserMangaCollectionRequestInputDTO) async -> Bool {
        do {
            try await apiClient.post(
                path: "collection/manga",
                body: input,
                temporaryAuth: nil
            )
            return true
        } catch {
            return false
        }
    }
    
    func removeMangaFromCollection(id: String) async -> Bool {
        do {
            let _: Int = try await apiClient.delete(
                path: "collection/manga/\(id)",
                queryParameters: [:],
                temporaryAuth: nil
            )
            return true
        } catch {
            return false
        }
    }
}

struct CollectionsTest: CollectionEndpoint {
    func getCollection() async -> [UserCollection] {
        return UserCollection.testList
    }
    
    func getMangaFromCollection(id: String) async -> UserCollection? {
        return UserCollection.testList.first { $0.manga.id.description == id }
    }
    
    func addMangaToCollection(input: UserMangaCollectionRequestInputDTO) async -> Bool {
        return true
    }
    
    func removeMangaFromCollection(id: String) async -> Bool {
        return true
    }
}
