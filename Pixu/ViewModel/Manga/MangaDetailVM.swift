//
//  MangaDetailVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 6/2/26.
//

import SwiftUI
import CommonsLib

@MainActor @Observable
final class MangaDetailVM {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager
    private let toastService: ToastService = .shared
    
    let manga: Manga
    var selectedManga: Manga?
    var collection: UserCollection? = nil
    
    var isInCollection: Bool {
        collection != nil
    }
    
    var filteredMangas: [Manga] = []
    private let filteredMangasPS = PageState()
    
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
        collection = databaseManager.getCollectionByMangaId(idManga: manga.id)
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
                toastService.show(type: .success, message: "Manga guardado")
            }
        } catch {
            print("Error al crear colección: \(error.localizedDescription)")
            toastService.show(type: .error, message: "Error al guardar Manga")
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
                toastService.show(type: .success, message: "Manga actualizdo")
            }
        } catch {
            print(
                "Error al actualizar colección: \(error.localizedDescription)"
            )
            toastService.show(type: .error, message: "Error actualizando Manga")
        }
    }
    
    func deleteCollection(collection: UserCollection) async {
        do {
            let result = await apiManager.collection.removeMangaFromCollection(id: collection.manga.id)
            
            if result {
                try databaseManager.deleteCollection(collection)
                self.collection = nil
                toastService.show(type: .success, message: "Manga eliminado")
            }
        } catch {
            print("Error al eliminar colección: \(error.localizedDescription)")
            toastService.show(type: .error, message: "Error eliminando Manga")
            
        }
    }

    func loadFilteredMangas() async {
       Task {
            guard let page = await filteredMangasPS.nextPage() else {
                return
            }

            let response = await apiManager.search.advancedSearchMangas(
                input: CustomSearchInputDTO(
                    searchContains: true,
                    searchTitle: nil,
                    searchAuthorFirstName: nil,
                    searchAuthorLastName: nil,
                    searchGenres: manga.genres.map(\.genre),
                    searchThemes: manga.themes.map(\.theme),
                    searchDemographics: nil
                ),
                page: page,
                per: 20
            )

            filteredMangas.append(contentsOf: response)

            let hasMore = response.count == 20
            await filteredMangasPS.finishLoading(hasMore: hasMore)
        }

    }
    
}
