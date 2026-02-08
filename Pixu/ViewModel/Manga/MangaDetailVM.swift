//
//  MangaDetailVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 6/2/26.
//

import SwiftUI

@MainActor @Observable
final class MangaDetailVM {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager

    let manga: Manga
    var collecetion: UserCollection? = nil

    var isInCollection: Bool {
        collecetion != nil
    }

    init(
        manga: Manga,
        apiManager: APIManager = .live,
        databaseManager: DatabaseManager = .shared
    ) {
        self.manga = manga
        self.apiManager = apiManager
        self.databaseManager = databaseManager
    }

    func searchCollection() async {
        collecetion = databaseManager.getCollectionByMangaId(idManga: manga.id)
    }

    func createCollection(collection: UserCollection) async {
        do {
            let result = await apiManager.collection
                .addMangaToCollection(
                    input: UserMangaCollectionRequestInputDTO(
                        manga: collection.manga.id,
                        volumesOwned: collection.volumesOwned,
                        readingVolume: collection.readingVolume,
                        completeCollection: collection.completeCollection
                    )
                )
            if result {
                try databaseManager.createCollection(collection)
                await searchCollection()
            }
        } catch {
            print("Error al crear colección: \(error.localizedDescription)")
        }
    }

    func updateCollection(collection: UserCollection) async {
        do {
            let result = await apiManager.collection
                .addMangaToCollection(
                    input: UserMangaCollectionRequestInputDTO(
                        manga: collection.manga.id,
                        volumesOwned: collection.volumesOwned,
                        readingVolume: collection.readingVolume,
                        completeCollection: collection.completeCollection
                    )
                )
            if result {
                try databaseManager.updateCollection(collection)
                await searchCollection()
            }
        } catch {
            print(
                "Error al actualizar colección: \(error.localizedDescription)"
            )
        }
    }

    func deleteCollection() async {
        guard let collecetion else { return }

        do {
            try databaseManager.deleteCollection(collecetion)
            // Limpiar la colección local después de eliminarla
            self.collecetion = nil
        } catch {
            print("Error al eliminar colección: \(error.localizedDescription)")
        }
    }
}
