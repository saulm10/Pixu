//
//  DataContainer.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import SwiftUI
import SwiftData

@ModelActor
actor DataContainer {
    private let apiManager: APIManager = .live
    
//    init(modelContainer: ModelContainer, apiManager: APIManager = .live) {
//        self.apiManager = apiManager
//        self.modelContainer = modelContainer
//        self.modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(modelContainer))
//    }
    
    /// Carga los datos iniciales solo si el usuario está autenticado
    func loadInitialData(isAuthenticated: Bool) async throws {
        guard isAuthenticated else {
            print("Usuario no autenticado. No se cargan datos.")
            return
        }
        
        let collections = await apiManager.collection.getCollection()
        try await loadCollections(collections: collections)
    }
    
    /// Sincroniza las colecciones con la base de datos local
    private func loadCollections(collections: [Collection]) async throws {
        for collection in collections {
            let id = collection.id
            let fetch = FetchDescriptor<Collection>(
                predicate: #Predicate { $0.id == id }
            )
            
            let existingCollections = try modelContext.fetch(fetch)
            
            if let existingCollection = existingCollections.first {
                // Actualizar colección existente
                existingCollection.completeCollection = collection.completeCollection
                existingCollection.readingVolume = collection.readingVolume
                existingCollection.volumesOwned = collection.volumesOwned
                existingCollection.manga = collection.manga
            } else {
                // Crear nueva colección
                let newCollection = Collection(
                    id: collection.id,
                    completeCollection: collection.completeCollection,
                    readingVolume: collection.readingVolume,
                    volumesOwned: collection.volumesOwned,
                    manga: collection.manga
                )
                modelContext.insert(newCollection)
            }
        }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    /// Limpia todos los datos locales (útil al cerrar sesión)
    func clearAllData() async throws {
        try modelContext.delete(model: Collection.self)
        try modelContext.delete(model: Manga.self)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
}
