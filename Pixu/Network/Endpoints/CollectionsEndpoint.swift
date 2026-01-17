//
//  Collection.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 13/1/26.
//

import Foundation
import NetworkAPI

protocol CollectionEndpoint {
    func getCollection() async -> [Collection]
    func getMangaFromCollection(id: String) async -> Collection?
    func addMangaToCollection(input: UserMangaCollectionRequestInputDTO) async -> Bool
    func removeMangaFromCollection(id: String) async -> Bool
}

struct Collections: CollectionEndpoint {
    let apiClient = NetworkManager.shared.client
    
    func getCollection() async -> [Collection] {
        do {
            return try await apiClient.get(
                path: "collection/manga",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return []
        }
    }
    
    func getMangaFromCollection(id: String) async -> Collection? {
        do {
            return try await apiClient.get(
                path: "collection/manga/\(id)",
                queryParameters: [:],
                temporaryAuth: nil
            )
        } catch {
            return nil
        }
    }
    
    func addMangaToCollection(input: UserMangaCollectionRequestInputDTO) async -> Bool {
        do {
            let _: Int = try await apiClient.post(
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
    func getCollection() async -> [Collection] {
        return Collection.testList
    }
    
    func getMangaFromCollection(id: String) async -> Collection? {
        return Collection.testList.first { $0.manga.id.description == id }
    }
    
    func addMangaToCollection(input: UserMangaCollectionRequestInputDTO) async -> Bool {
        return true
    }
    
    func removeMangaFromCollection(id: String) async -> Bool {
        return true
    }
}
